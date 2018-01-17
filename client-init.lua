dofile('initialize_config.lc')
dofile('led-blink.lc')
dofile('basic-functions.lc')

if file.exists('cache/SETUP_FINISHED') then 
print('load main features')
    --LOAD MAIN FEATURES
else
    print('Initialize setup')
    dofile('client-setup-ap-init.lc')()
    dofile('client-setup-web-server.lc')()
end
