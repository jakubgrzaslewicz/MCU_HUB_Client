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
    for key,value in pairs(registered_config_keys) do --pseudocode
        _,_,CONFIG_VAL = string.find(request,"-"..value.."=(.*)")
        if CONFIG_VAL ~= nil then
            CONFIG_VAL = trim(CONFIG_VAL)
            CONFIG_KEY = value
            break 
        end
    end
    if CONFIG_KEY == nil then
        buff[#buff+1] = generate_json_error("Unproperly prepared request. Your key may be not allowed.",nil)
        blink('.','.','-')
        send_data()
    else
        if CONFIG_VAL ~= nil and CONFIG_VAL:match("%S") ~= nil then
            if CONFIG_KEY == 'WIFI_AP_PASS' then
                if string.len(CONFIG_VAL) <8 then
                    buff[#buff+1] = generate_json_error("PASS field must be at least 8 chars long",nil)
                    blink('.','-','-')
                    send_data()
                    return;
                end
            end
            print("Setting configuration "..CONFIG_KEY.." field to: "..CONFIG_VAL)
            dofile('client-config-manager.lc')
            save(CONFIG_KEY,CONFIG_VAL)
            blink('.','.','.')
            buff[#buff+1] = generate_json_success("Config value was set successfully",nil)
            send_data()
            collectgarbage()
        else
            buff[#buff+1] = generate_json_error("Field must be specified and not empty",nil)
            blink('.','.','-')
            send_data()
        end
    end
end
