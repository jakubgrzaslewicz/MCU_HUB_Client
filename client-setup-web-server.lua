function receiver(client,request)
    --print(request)
    --mcu_do=string.sub(payload,postparse[2]+1,#payload)
function listap(t) -- (SSID : Authmode, RSSI, BSSID, Channel)
    print("\n\t\t\tSSID\t\t\t\t\tBSSID\t\t\t  RSSI\t\tAUTHMODE\t\tCHANNEL")
    for bssid,v in pairs(t) do
        local ssid, rssi, authmode, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]*)")
        print(string.format("%32s",ssid).."\t"..bssid.."\t  "..rssi.."\t\t"..authmode.."\t\t\t"..channel)
        client:send('<option value="'..ssid..'">'..ssid..'</option>\n')
    end
end

    client:send("<h1> Hello, NodeMCU!!! </h1>")
        
    client:send('<!DOCTYPE HTML>\n')
    client:send('<html>\n')
    client:send('<head><meta  content="text/html; charset=utf-8">\n')
    client:send('<title>TEMP CONFIG</title></head>\n')
    client:send('<body><h1>MCU_HUB_Client Configuration page!</h1>\n')
    
    client:send('<form action="" method="POST">\n')
    client:send('<select name="network_to_connect">\n')
    wifi.sta.getap(1, listap)
    client:send('</select>\n')
    client:send('<input type="submit" name="mcu_do" value="Update LED">\n')
    client:send('</body></html>\n')
    collectgarbage()
end
return function ()
    print('Trying to start www server on port :80')
    print(node.heap())
    sv = net.createServer(net.TCP, 30)
    if sv then
        print("WWW server started")
        sv:listen(80, function(conn)
            conn:on("receive", receiver)
            conn:on("sent",function(conn) conn:close() end)
        end)
    else
        print('Cant start web server on port 80')
    end
   collectgarbage();
end
