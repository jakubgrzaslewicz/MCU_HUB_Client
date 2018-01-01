-- if file.exists("compile.lc") then
-- dofile("compile.lc")
-- else
--    dofile("compile.lua")
-- end
-- dofile("client-init.lc")
wifi.setmode(wifi.STATIONAP,false)
wifi.ap.config({ssid="AKJSNKJASNFAS2", max = 1, save = false})
wifi.ap.setip({ip = '192.168.1.1', netmask = '255.255.255.0', gateway = '192.168.1.1'});
dofile('client-register-wifi-events.lc')
dofile('client-setup-web-server.lua')()

