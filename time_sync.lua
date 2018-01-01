function syncTime()
    sntp.sync("pool.ntp.org",
      function(sec, usec, server, info)
      
        rtctime.set(sec+3600, usec)
        tm = rtctime.epoch2cal(rtctime.get())
        if tm["mon"] == 10 then
            if tm["day"] >=28 then
                rtctime.set(sec+3600, usec) 
            end
        end
        if tm["mon"] == 3 then
            if tm["day"] <=25 then
                rtctime.set(sec+3600, usec) 
            end
        end
        if tm["mon"] >10 or tm["mon"] <3 then
            rtctime.set(sec+3600, usec) 
        end
        tm = rtctime.epoch2cal(rtctime.get())
        print(string.format("Current time is: %04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
        print("Startup will resume momentarily, you have 5 seconds to abort.")
        print("Waiting...") 
        tmr.create():alarm(5000, tmr.ALARM_SINGLE, startup)
      end,
      function()
       print('Time sync failed! Trying again in 1 second...')
       tmr.delay(10000)
       syncTime()
      end,
      true
    )
end