
function receiver(client,request)
    print(request)
    _, _, method, url, vars = string.find(request, "([A-Z]+) /([^?]*)%??(.*) HTTP")
    if method == 'GET' then
        if url == "get-ap-list" then 
            print('Executing task: get-ap-list')
            dofile('json-api-get-ap-list.lc')(client,request)
        elseif url == "device-info" then
            print('Executing task: device-info')
            dofile('json-api-device-info.lc')(client,request)
        else
            client:send(dofile('client-standard-responses.lc')(404))
        end
    elseif method == 'POST' then
        if url == "connect-to-ap" then 
            print('Executing task: connect-to-ap')
            dofile('json-api-connect-to-ap.lc')(client,request)
        else
            client:send(dofile('client-standard-responses.lc')(404))
        end
    else
        client:send(dofile('client-standard-responses.lc')(404))
    end
end

return function ()
    print('Trying to start www server on port :80')
    print(node.heap())
    sv = net.createServer(net.TCP, 30)
    if sv then
        print("WWW server started")
        sv:listen(80, function(conn)
            conn:on("receive", receiver)
            conn:on("sent",function(conn) if conn ~= nil then conn:close() end end)
        end)
    else
        print('Cant start web server on port 80')
    end
   collectgarbage();
end
