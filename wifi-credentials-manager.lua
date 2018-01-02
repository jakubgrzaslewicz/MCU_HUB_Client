local CACHE_WIFI_SSID = 'cache/WIFI_SSID'
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
function write_to_file(filename,content)
    fd = file.open(filename, 'w')
    fd.write(trim_white_chars(content))
    fd:close(); fd = nil
end