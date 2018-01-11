function blink(first,second,third)
    local function short()
        gpio.mode(4, gpio.OUTPUT)
        gpio.write(4, gpio.LOW)
        tmr.delay(50000)
        gpio.mode(4, gpio.INPUT)
        gpio.write(4, gpio.HIGH)
    end
    local function long()
        gpio.mode(4, gpio.OUTPUT)
        gpio.write(4, gpio.LOW)
        tmr.delay(350000)
        gpio.mode(4, gpio.INPUT)
        gpio.write(4, gpio.HIGH)
    end
     function wait()
        tmr.delay(400000)
    end
    local function execute(num)
        if num ~= nil then
            if num ~= '-' then
                short()
            else
                long()
            end
            wait()
        end
    end
    execute(first)
    execute(second)
    execute(third)
end