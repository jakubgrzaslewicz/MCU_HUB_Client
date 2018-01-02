function total_size_of_array_entries(arr)
    local content_size = 0
    for index, line in pairs(arr) do
        content_size = content_size + string.len(line)
    end
    return content_size
end
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
function generate_json_error(message)
    local arr = {}
    arr['SUCCESS'] = false
    arr['MESSAGE'] = message
    return sjson.encode(arr)
end
function generate_json_success(message,data)
    local arr = {}
    arr['SUCCESS'] = true
    arr['MESSAGE'] = message
    arr['DATA'] = data
    return sjson.encode(arr)
end
return function (client,request)
    headers = dofile('client-standard-responses.lc')(200)
    buff = {}
    local function send(localSocket)
        if buff ~= nil then 
            if #buff > 0 then
                localSocket:send(table.remove(buff, 1))
            else
                if conn ~= nil then conn:close() end
                buff = nil
            end
        else
            if conn ~= nil then conn:close() end
            buff = nil
        end
    end
    local function send_data()
        headers = headers..'Content-Length:'..total_size_of_array_entries(buff)..'\r\n\r\n'
        content_size = nil
        table.insert(buff, 1, headers)
        headers = nil
        client:on("sent", send)
        send(client)
    end
    
    _,_,SSID = string.find(request,"SSID=(.*)\n")
    _,_,PASSWORD = string.find(request,"PASS=(.*)")
    if SSID == nil or SSID == '' or PASSWORD == nil or PASSWORD == '' then
        buff[#buff+1] = generate_json_error("SSID and PASS fields must be specified and not empty")
        send_data()
    else
        print('Trying to connect with access point using SSID: '..SSID..' and PASSWORD: '..PASSWORD)
        dofile('wifi-credentials-manager.lc')
        save_ssid(SSID)
        conf = {}
        conf.pwd = PASSWORD
        conf.save = false
        conf.bssid=nil
        conf.ssid = get_saved_ssid()
        wifi.sta.config(conf)
        wifi.sta.connect()
        time = tmr.now()
        config = wifi.sta.getconfig(true)
        print(sjson.encode(config))
        tmr.alarm(1, 1000, 1, 
            function() 
                if wifi.sta.status() == wifi.STA_GOTIP then 
                    print("Station: connected! IP: " .. wifi.sta.getip())
                    buff[#buff+1] = generate_json_success("Connected to AP successfully",{IP=wifi.sta.getip()})
                    tmr.stop(1)
                    send_data()
                else
                    if tmr.now()-time > 8000000 then -- about 8 secs
                        print("Timeout!")
                        buff[#buff+1] = generate_json_error("Connection failed. Reason: "..wifi.sta.status() )
                        tmr.stop(1)
                        send_data()
                    end
                    if wifi.sta.status() == wifi.STA_IDLE          then print("Station: idling") end
                    if wifi.sta.status() == wifi.STA_CONNECTING       then print("Station: connecting") end
                    if wifi.sta.status() == wifi.STA_WRONGPWD    then print("Station: wrong password") end
                    if wifi.sta.status() == wifi.STA_APNOTFOUND    then print("Station: AP not found") end
                    if wifi.sta.status() == wifi.STA_FAIL    then print("Station: connection failed") end
                end 
            end)
        collectgarbage()
    end
end
