local CONFIG_FILE_PREFIX = 'cache/CONFIG_'

function get(KEY)
    filename = CONFIG_FILE_PREFIX..KEY
    if file.exists(filename) then
        content = trim(FileReadFirstLine(filename))
        if content ~= '' then
            return content
        else
            return nil
        end
    else
        return nil
    end
end
function save(KEY,VALUE)
    dofile('configuration-keys.lc')
    if arrayHasValue(registered_config_keys, KEY) then
        filename = CONFIG_FILE_PREFIX..KEY
        if file.exists(filename) then
            file.remove(filename)
        end
        FileWrite(filename,VALUE)
        return true
    else
        return false
    end
end

