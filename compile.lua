local compileAndRemoveIfNeeded = function(f)
   if file.exists(f) then
      print('Compiling:', f)
      node.compile(f)
      file.remove(f)
      collectgarbage()
   end
end

local serverFiles = {
   'initialize_config.lua',
   'compile.lua',
   'client-init.lua',
   'client-setup-ap-init.lua',
   'client-setup-web-server.lua',
   'client-register-wifi-events.lua'
}
for i, f in ipairs(serverFiles) do compileAndRemoveIfNeeded(f) end

compileAndRemoveIfNeeded = nil
serverFiles = nil
collectgarbage()
