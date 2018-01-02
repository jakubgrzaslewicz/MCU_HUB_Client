return function (code)
    if code == 404 then
        print('Function not found!')
        return 'HTTP/1.0 404 Not Found\r\nServer: MCU_HUB_Client\r\nContent-Type: text/html\r\n\r\n<html><head><title>Not Found</title></head><body><h1>404 - Not Found</h1></body></html>'
    elseif code == 200 then
        return 'HTTP/1.0 200 OK\r\nServer: MCU_HUB_Client\r\nContent-Type: application/json\r\nConnection: close\r\n'
    elseif code == 400 then
        return 'HTTP/1.0 400 Bad Request\r\nServer: MCU_HUB_Client\r\nContent-Type: application/json\r\nConnection: close\r\n'
    else
        return ''
    end
end
