do
    local DHT22_PIN = 2
    local MQTT_HUMI = "/atmosphere/humi"
    local MQTT_TEMP = "/atmosphere/temp"
    local PUBLISH_INTERVAL = 3000

	local function dht22Worker()
        status, temp, humi = dht.read(DHT22_PIN)

        if status == dht.OK then
            mqtt_publish(MQTT_HUMI, humi)
            mqtt_publish(MQTT_TEMP, temp)
        elseif status == dht.ERROR_CHECKSUM then
            print( "DHT Checksum error." )
        elseif status == dht.ERROR_TIMEOUT then
            print( "DHT timed out." )
        end
	end

    tmr.create():alarm(PUBLISH_INTERVAL, tmr.ALARM_AUTO, dht22Worker)
end
