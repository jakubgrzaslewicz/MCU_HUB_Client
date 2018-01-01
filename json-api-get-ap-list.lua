function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
return function (client,request)
    buff = {"HTTP/1.0 200 OK\r\nServer: NodeMCU on ESP8266\r\nContent-Type: application/json\r\n\r\n"}
    local function send(localSocket)
        if buff ~= nil then 
            if #buff > 0 then
              localSocket:send(table.remove(buff, 1))
            else
              buff = nil
            end
        else
            buff = nil
        end
    end
    function listap(t)
        buff[#buff + 1] = '['
        local x = 0
        for bssid,v in pairs(t) do
            local ssid, rssi, authmode, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]*)")
            --print(string.format("%32s",ssid).."\t"..bssid.."\t  "..rssi.."\t\t"..authmode.."\t\t\t"..channel)
            buff[#buff + 1] = '{"SSID":"'..ssid..'","BSSID":"'..bssid..'","RSSI":'..rssi..',"AUTHMODE":'..authmode..',"CHANNEL":'..channel..'}'
            x = x+1
            if tablelength(t) ~= x then buff[#buff + 1] = ',' end
        end
        x=nil
        buff[#buff + 1] = ']'
        client:on("sent", send)
        send(client)
    end
    wifi.sta.getap(1, listap)
    collectgarbage()
end
