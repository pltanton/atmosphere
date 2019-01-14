mqttClient = mqtt.Client("atmosphere", 120, MQTT_USER, MQTT_PASS)

function handle_mqtt_connect(client) 
    print("MQTT connected")
end

function handle_mqtt_error(client, reason) 
    print("can't connect to mqtt")
  tmr.create():alarm(10 * 1000, tmr.ALARM_SINGLE, mqtt_connect)
end

function mqtt_connect()
    mqttClient:connect(MQTT_HOST, MQTT_PORT, 0, 0, handle_mqtt_connect, handle_mqtt_error)
end

function mqtt_publish(topic, message)
    print("Trying to publish "..topic..": "..message)
    mqttClient:publish(topic, message, 0, 0)
end

mqtt_connect()
