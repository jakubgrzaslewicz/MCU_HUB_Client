return function (client,request)
    local buff = dofile('client-standard-responses.lc')(200)
    majorVer, minorVer, devVer, chipid, flashid, flashsize, flashmode, flashspeed = node.info()
    local arr = {}
    arr['DEVICE'] = {}
    arr['MCU_HUB_CLIENT'] = {}
    arr['DEVICE']['MAJOR_VER'] = majorVer
    arr['DEVICE']['MINOR_VER'] = minorVer
    arr['DEVICE']['DEV_VER'] = devVer
    arr['DEVICE']['CHIP_ID'] = chipid
    arr['DEVICE']['FLASH_ID'] = flashid
    arr['DEVICE']['FLASH_SIZE'] = flashsize
    arr['DEVICE']['FLASH_MODE'] = flashmode
    arr['DEVICE']['FLASH_SPEED'] = flashspeed
    arr['MCU_HUB_CLIENT']['JSON-API-VER'] = '1.0'
    fd = file.open('cache/AP_NAME','r')
    if fd then
        ap_name = (fd:readline():gsub("^%s*(.-)%s*$", "%1"))
        arr['MCU_HUB_CLIENT']['AP_SSID'] = ap_name
        fd:close(); fd = nil
    end
    json = sjson.encode(arr)
    buff = buff..'Content-Length:'..string.len(json)..'\r\n\r\n'
    buff = buff..json
    client:send(buff)
    buff = nil
    json = nil
    client:on("sent",function(client) client:close() end)
    collectgarbage()
end
