local CACHE_WIFI_SSID = 'cache/WIFI_SSID'
local CACHE_WIFI_PASS = 'cache/WIFI_PASS'
local CACHE_WIFI_AP_PASS = 'cache/WIFI_AP_PASS'
function trim_white_chars(str)
    return str:gsub("^%s*(.-)%s*$", "%1")
end
function get_saved_ssid()
    if file.exists(CACHE_WIFI_SSID) then
        fd = file.open(CACHE_WIFI_SSID,'r')
        if fd then
            ssid = trim_white_chars(fd:readline())
            fd:close(); fd = nil
            if ssid ~= '' then
                return ssid
            else
                return nil
            end
        else
            return nil
        end
    else
        return nil
    end
end
function save_ssid(ssid)
    if file.exists(CACHE_WIFI_SSID) then
        file.remove(CACHE_WIFI_SSID)
    end
    write_to_file(CACHE_WIFI_SSID,ssid)
end
function get_saved_pass()
    if file.exists(CACHE_WIFI_PASS) then
        fd = file.open(CACHE_WIFI_PASS,'r')
        if fd then
            ssid = trim_white_chars(fd:readline())
            fd:close(); fd = nil
            if ssid ~= '' then
                return ssid
            else
                return nil
            end
        else
            return nil
        end
    else
        return nil
    end
end
function save_pass(pass)
    if file.exists(CACHE_WIFI_PASS) then
        file.remove(CACHE_WIFI_PASS)
    end
    write_to_file(CACHE_WIFI_PASS,pass)
end
function get_saved_ap_pass()
    if file.exists(CACHE_WIFI_AP_PASS) then
        fd = file.open(CACHE_WIFI_AP_PASS,'r')
        if fd then
            ssid = trim_white_chars(fd:readline())
            fd:close(); fd = nil
            if ssid ~= '' then
                return ssid
            else
                return nil
            end
        else
            return nil
        end
    else
        return nil
    end
end
function save_ap_pass(pass)
    if file.exists(CACHE_WIFI_AP_PASS) then
        file.remove(CACHE_WIFI_AP_PASS)
    end
    write_to_file(CACHE_WIFI_AP_PASS,pass)
end
function write_to_file(filename,content)
    fd = file.open(filename, 'w')
    fd.write(trim_white_chars(content))
    fd:close(); fd = nil
end
