local CACHE_FILE_AP_NAME = 'cache/AP_NAME'

local function getApName()
    if file.exists(CACHE_FILE_AP_NAME) then
        ap_name = trim(FileReadFirstLine(CACHE_FILE_AP_NAME))
        if stringStartsWith(ap_name, "MCU-HUB-Client-") then
            return ap_name
        end
        --If we get here, the file is corrupted.
        --Let's remove it and create new one by calling this function again
        file.remove(CACHE_FILE_AP_NAME)
        return getApName()
    else
        local name = 'MCU-HUB-Client-'
        for i=1,6 do 
            rand = math.random(2)
            if rand == 1 then
                name = name .. string.char(math.random(48,57))
            elseif rand == 2 then
                name = name .. string.char(math.random(65,90))
            end
        end
        FileWrite(CACHE_FILE_AP_NAME,name)
        return name
    end
end
return function ()
    local ap_name = getApName()
    
    --wifi.ap.config({ssid=ap_name, pwd = 'MCU-HUB_PA$$', max = 1, auth = wifi.WPA_WPA2_PSK})
    wifi.sta.clearconfig()
    wifi.setmode(wifi.STATIONAP,false)
    wifi.ap.config({ssid=ap_name, max = 1, save = false})
    wifi.ap.setip({ip = '10.10.0.1', netmask = '255.255.255.0', gateway = '10.10.0.1'});
    print("Access point config: SSID("..ap_name.."), PASSWORD(MCU-HUB_PA$$), IP(192.168.1.1), NETMASK(255.255.255.0), GATEWAY(192.168.1.1)")
    ap_name=nil
    CACHE_FILE_AP_NAME=nil
    collectgarbage()
    dofile('client-register-wifi-events.lc')
    collectgarbage()
end
