function total_size_of_array_entries(arr)
    local content_size = 0
    for index, line in pairs(arr) do
        content_size = content_size + string.len(line)
    end
    return content_size
end
return function (client,request)
    buff = {}
    headers = dofile('client-standard-responses.lc')(200)
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
    function listap(t)
        local json = {}
        for bssid,v in pairs(t) do
            local ssid, rssi, authmode, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]*)")
            local arr = {}
            arr['SSID'] = ssid
            arr['RSSI'] = rssi
            arr['AUTHMODE'] = authmode
            arr['CHANNEL'] = channel
            arr['BSSID'] = bssid
            json[#json + 1] = arr
            arr = nil
        end
        buff[#buff + 1] = sjson.encode(json)
        json = nil
        headers = headers..'Content-Length:'..total_size_of_array_entries(buff)..'\r\n\r\n'
        content_size = nil
        table.insert(buff, 1, headers)
        headers = nil
        client:on("sent", send)
        send(client)
    end
    wifi.sta.getap(1, listap)
    collectgarbage()
end
