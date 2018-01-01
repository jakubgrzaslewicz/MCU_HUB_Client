return function (code)
    if code == 404 then
        return 'HTTP/1.0 404 Not Found\r\nServer: NodeMCU on ESP8266\r\nContent-Type: text/html\r\n\r\n<html><head><title>Not Found</title></head><body><h1>404 - Not Found</h1></body></html>'
    else 
        return ''
    end
end