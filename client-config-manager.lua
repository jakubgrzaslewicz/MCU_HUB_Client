local CONFIG_FILE_PREFIX = 'cache/CONFIG_'
function trim_white_chars(str)
    return str:gsub("^%s*(.-)%s*$", "%1")
end
function get(KEY)
    filename = CONFIG_FILE_PREFIX..KEY
    if file.exists(filename) then
        fd = file.open(filename,'r')
        if fd then
            content = trim_white_chars(fd:readline())
            fd:close(); fd = nil
            if content ~= '' then
                return content
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
function save(KEY,VALUE)
    dofile('configuration-keys.lc')
    if has_value(registered_config_keys, KEY) then
        filename = CONFIG_FILE_PREFIX..KEY
        if file.exists(filename) then
            file.remove(filename)
        end
        write_to_file(filename,VALUE)
        return true
    else
        return false
    end
end
function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end
function write_to_file(filename,content)
    fd = file.open(filename, 'w')
    fd.write(trim_white_chars(content))
    fd:close(); fd = nil
end

function READ_FILE(filename)
    if file.exists(filename) then
        fd = file.open(filename,'r')
        if fd then
            content = trim_white_chars(fd:readline())
            fd:close(); fd = nil
            if content ~= '' then
                return content
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
