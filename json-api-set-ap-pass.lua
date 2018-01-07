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
    
    _,_,PASSWORD = string.find(request,"PASS=(.*)")
    if PASSWORD ~= nil and PASSWORD:match("%S") ~= nil then
        if string.len(PASSWORD) <8 then
            buff[#buff+1] = generate_json_error("PASS fields must be at least 8 chars long",nil)
            send_data()
            return;
        end
        print("Setting AP passwort to: "..PASSWORD)
        dofile('wifi-credentials-manager.lc')
        save_ap_pass(PASSWORD)
        buff[#buff+1] = generate_json_success("Password was set successfully",nil)
        send_data()
        collectgarbage()
    else
        buff[#buff+1] = generate_json_error("PASS fields must be specified and not empty",nil)
        send_data()
    end
end
