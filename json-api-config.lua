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
    CONFIG_VAL=nil
    CONFIG_KEY=nil
    dofile('configuration-keys.lc')
    for key,value in pairs(registered_config_values) do --pseudocode
        _,_,CONFIG_VAL = string.find(request,value.."=(.*)")
        CONFIG_KEY = value
        if CONFIG_VAL ~= nil then break end
        buff[#buff+1] = generate_json_error("Unproperly prepared request. Your key may be not allowed.",nil)
        send_data()
        return;
    end
    
    if CONFIG_KEY == 'WIFI_AP_PASS' and (CONFIG_VAL ~= nil and CONFIG_VAL:match("%S") ~= nil) then
        if string.len(PASSWORD) <8 then
            buff[#buff+1] = generate_json_error("PASS field must be at least 8 chars long",nil)
            send_data()
            return;
        end
        print("Setting configuration "..CONFIG_KEY.." field to: "..CONFIG_VAL)
        dofile('client-config-manager.lc')
        save(CONFIG_KEY,CONFIG_VAL)
        buff[#buff+1] = generate_json_success("Config value was set successfully",nil)
        send_data()
        collectgarbage()
    else
        buff[#buff+1] = generate_json_error("Field must be specified and not empty",nil)
        send_data()
    end
end