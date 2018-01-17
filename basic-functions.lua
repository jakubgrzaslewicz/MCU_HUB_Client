function stringStartsWith(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end
function trim(str)
    return str:gsub("^%s*(.-)%s*$", "%1")
end
function arrayHasValue(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end
function FileWrite(filename,content)
    fd = file.open(filename, 'w')
    fd.write(trim(content))
    fd:close(); fd = nil
end

function FileReadFirstLine(filename)
    if file.exists(filename) then
        fd = file.open(filename,'r')
        if fd then
            content = trim(fd:readline())
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
function total_size_of_array_entries(arr)
    local content_size = 0
    for index, line in pairs(arr) do
        content_size = content_size + string.len(line)
    end
    return content_size
end
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
