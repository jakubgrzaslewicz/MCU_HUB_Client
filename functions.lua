--functions
local publicClass={};

function publicClass.randomInit()
  math.randomseed(tmr.now()+node.chipid())
  math.random()
  math.random()
  math.random()
end
function publicClass.getApName()
  if file.exists(CACHE_FILE_AP_NAME) then
    local string_helpers = require("string_helpers");
    fd = file.open(CACHE_FILE_AP_NAME,'r')
    if fd then
      local ap_name = string_helpers.trim(fd:readline())
      fd:close(); fd = nil
      if ap_name ~= '' then return ap_name end
    end
    --If we get here, the file is corrupted.
    --Let's remove it and create new one by calling this function again
    file.remove(CACHE_FILE_AP_NAME)
    return getApName()
  else 
    local name = 'MCU_HUB_Client_'
    for i=1,6 do 
      rand = math.random(3)
      if rand == 1 then
        name = name .. string.char(math.random(48,57))
      elseif rand == 2 then
        name = name .. string.char(math.random(65,90))
      elseif rand == 3 then
        name = name .. string.char(math.random(97,122))
      else
      end
    end
    fd = file.open(CACHE_FILE_AP_NAME, 'w')
    fd.write(name)
    fd:close(); fd = nil
    return name
  end
end
function publicClass.clearAllData()
    file.remove(CACHE_FILE_AP_NAME)
    file.remove(CACHE_FILE_SETUP_FINISHED)
    wifi.sta.clearconfig()
end
return publicClass; 