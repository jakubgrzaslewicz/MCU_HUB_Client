
function receiver(client,request)
    _, _, method, url, vars = string.find(request, "([A-Z]+) /([^?]*)%??(.*) HTTP")
    print(url)
    if url == "get-ap-list" then 
        print('Executing task: get-ap-list')
        dofile('json-api-get-ap-list.lc')(client,request)
    else
        print('Function not found!')
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
            conn:on("sent",function(conn) conn:close() end)
        end)
    else
        print('Cant start web server on port 80')
    end
   collectgarbage();
end
