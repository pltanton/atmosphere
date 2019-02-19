do
    local MQTT_LIGHT = "/atmosphere/light"
    local PUBLISH_INTERVAL = 3000

    local A_MAX = 1024
    local V = 3.3
    local R = 10000
    local R_REFERAL = 500000

    if adc.force_init_mode(adc.INIT_ADC)
    then
      node.restart()
      return
    end

	local function ldrWorker()
        ag = adc.read(0)
        vg = ag * V / A_MAX
        rg = R * vg / (V - vg) 

        lux = R_REFERAL / rg

        mqtt_publish(MQTT_LIGHT, lux)
	end

    tmr.create():alarm(PUBLISH_INTERVAL, tmr.ALARM_AUTO, ldrWorker)
end
