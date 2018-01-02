local wifi_connect_event = function(T) 
  print("Connection to AP("..T.SSID..") established!")
  print("Waiting for IP address...")
  if disconnect_ct ~= nil then disconnect_ct = nil end  
end

local wifi_got_ip_event = function(T)     
  print("Wifi connection is ready! IP address is: "..T.IP)
  --syncTime()
end

local wifi_disconnect_event = function(T)
  if T.reason == wifi.eventmon.reason.ASSOC_LEAVE then 
    return 
  end
local total_tries = 15
  print("\nWiFi connection to AP("..T.SSID..") has failed!")

  for key,val in pairs(wifi.eventmon.reason) do
    if val == T.reason then
      print("Disconnect reason: "..val.."("..key..")")
      break
    end
  end

  if disconnect_ct == nil then 
    disconnect_ct = 1 
  else
    disconnect_ct = disconnect_ct + 1 
  end
  if disconnect_ct < total_tries then 
    print("Retrying connection...(attempt "..(disconnect_ct+1).." of "..total_tries..")")
  else
    wifi.sta.disconnect()
    print("Aborting connection to AP!")
    disconnect_ct = nil  
  end
end

local wifi_client_connected_event = function(T)
  print("New client connected: "..T.MAC)
end
local wifi_client_disconnected_event = function(T)
  print("Client disconnected: "..T.MAC)
end


--wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, wifi_connect_event)
--wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, wifi_got_ip_event)
--wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, wifi_disconnect_event)
wifi.eventmon.register(wifi.eventmon.AP_STACONNECTED, wifi_client_connected_event)
wifi.eventmon.register(wifi.eventmon.AP_STADISCONNECTED, wifi_client_disconnected_event)
