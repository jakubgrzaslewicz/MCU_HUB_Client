local publicClass={};
function publicClass.initialize(functions)
    print("Preparing setup phase...")
    print("Creating ACCESS POINT...: ")
    wifi.setmode(wifi.STATIONAP)
    ap_name = functions.getApName()
    wifi.ap.config({ssid=ap_name, pwd = 'MCU_HUB_PA$$', max = 1, auth = wifi.WPA_WPA2_PSK})
    
    wifi.ap.setip({ip = '192.168.1.1', netmask = '255.255.255.0', gateway = '192.168.1.1'});
    print("Access point config: SSID("..ap_name.."), PASSWORD(MCU_HUB_PA$$), IP(192.168.1.1), NETMASK(255.255.255.0), GATEWAY(192.168.1.1)")
    ap_name=nil
    CACHE_FILE_AP_NAME=nil
    functions = nil
    collectgarbage('collect')
    create_configuration_server()
end
function create_configuration_server()
    print('Starting www server on port :80')
    print(node.heap())
    srv=net.createServer(net.TCP)
    srv:listen(80,function(conn)
        conn:on("receive", function(client,request)
            local buf = "";
            local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
            if(method == nil)then
                _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
            end
            local _GET = {}
            if (vars ~= nil)then
                for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                    _GET[k] = v
                end
            end
            buf = buf.."<h1> ESP8266 Web Server</h1>";
            buf = buf.."<p>GPIO0 <a href=\"?pin=ON1\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF1\"><button>OFF</button></a></p>";
            buf = buf.."<p>GPIO2 <a href=\"?pin=ON2\"><button>ON</button></a>&nbsp;<a href=\"?pin=OFF2\"><button>OFF</button></a></p>";
            local _on,_off = "",""
            if(_GET.pin == "ON1")then
                  gpio.write(led1, gpio.HIGH);
            elseif(_GET.pin == "OFF1")then
                  gpio.write(led1, gpio.LOW);
            elseif(_GET.pin == "ON2")then
                  gpio.write(led2, gpio.HIGH);
            elseif(_GET.pin == "OFF2")then
                  gpio.write(led2, gpio.LOW);
            end
            client:send(buf);
            client:close();
            collectgarbage();
        end)
    end)
end
return publicClass;