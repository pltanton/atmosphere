do
    local MHZ19_PIN = 5
	local CO2_BUFFER_MAX_SIZE = 50
    local PUBLISH_INTERVAL = 5000
    local MQTT_TOPIC = "/atmosphere/co2"

    gpio.mode(MHZ19_PIN, gpio.INT)

	local lowDuration = 0
	local highDuration = 0
	local lastTimestamp = 0
	local co2Buffer = {}

    local function handleMHZ19Trigger(level, timestamp) 
		if level == gpio.LOW then
			highDuration = timestamp - lastTimestamp
		else
			lowDuration = timestamp - lastTimestamp
			lastTimestamp = timestamp

			local co2 = math.floor(5000 * (highDuration - 2) / (highDuration + lowDuration - 4)) 

			table.insert(co2Buffer, co2)
            if #co2Buffer > CO2_BUFFER_MAX_SIZE then
                table.remove(co2Buffer, 1)
            end
		end
		lastTimestamp = timestamp
    end

	local function publishCO2()
        if #co2Buffer == 0 then
            print("Can't publish CO2: empty buffer")
            return
        end

        local co2Values = co2Buffer
        co2Buffer = {}

        table.sort(co2Values)
        local median = math.floor(co2Values[math.floor(#co2Values / 2 + 1)])

        mqtt_publish(MQTT_TOPIC, median)
	end

    gpio.trig(MHZ19_PIN, "both", handleMHZ19Trigger)
    tmr.create():alarm(PUBLISH_INTERVAL, tmr.ALARM_AUTO, publishCO2)
end
