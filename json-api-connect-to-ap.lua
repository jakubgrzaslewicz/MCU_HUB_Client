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
function generate_json_error(message,data)
    local arr = {}
    arr['SUCCESS'] = false
    arr['MESSAGE'] = message
    arr['DATA'] = data
    return sjson.encode(arr)
end
function generate_json_success(message,data)
    local arr = {}
    arr['SUCCESS'] = true
    arr['MESSAGE'] = message
    arr['DATA'] = data
    return sjson.encode(arr)
end
function get_reason(status)
    if status == wifi.STA_IDLE          then return "STATION IDLE" end
    if status == wifi.STA_CONNECTING       then return "CONNECTION LOST" end
    if status == wifi.STA_WRONGPWD    then return "WRONG PASSWORD" end
    if status == wifi.STA_APNOTFOUND    then return "AP NOT FOUND" end
    if status == wifi.STA_FAIL    then return "CONNECTION FAILED" end
    return "UNKNOWN"
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
    if (SSID ~= nil and SSID:match("%S") ~= nil) and (PASSWORD ~= nil and PASSWORD:match("%S") ~= nil)then
        gpio.mode(4, gpio.OUTPUT)
        gpio.write(4, gpio.LOW)
        print('Trying to connect with access point using SSID: '..SSID..' and PASSWORD: '..PASSWORD)
        dofile('client-config-manager.lc')
        save('WIFI_SSID',SSID)
        save('WIFI_PASS',PASSWORD)
        conf = {}
        conf.pwd = get('WIFI_PASS')
        conf.save = false
        conf.bssid=nil
        conf.ssid = get('WIFI_SSID')
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
                elseif wifi.sta.status() == wifi.STA_WRONGPWD or wifi.sta.status() == wifi.STA_APNOTFOUND  then
                        buff[#buff+1] = generate_json_error("Connection failed.",{REASON_CODE=wifi.sta.status(), REASON = get_reason(wifi.sta.status())} )
                        tmr.stop(1)
                        send_data()
                else
                    if tmr.now()-time > 8000000 then -- about 8 secs
                        print("Timeout!")
                        buff[#buff+1] = generate_json_error("Connection failed.",{REASON_CODE=wifi.sta.status(), REASON = get_reason(wifi.sta.status())} )
                        tmr.stop(1)
                        send_data()
                    end
                end 
                
                print("STATION: "..get_reason(wifi.sta.status()))
            end)
        collectgarbage()
    else
        buff[#buff+1] = generate_json_error("SSID and PASS fields must be specified and not empty",nil)
        send_data()
    end
end
