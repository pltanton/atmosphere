RGBLed = {}
RGBLed.__index = RGBLed

function RGBLed.new(red_pin, green_pin, blue_pin)
    local self = setmetatable({}, RGBLed)
    self.red_pin = red_pin
    self.green_pin = green_pin
    self.blue_pin = blue_pin

    pwm.setup(red_pin, 500, 1000)
    pwm.setup(green_pin, 500, 1000)
    pwm.setup(blue_pin, 500, 1000)
    pwm.start(red_pin)
    pwm.start(green_pin)
    pwm.start(blue_pin)

    return self
end

function RGBLed.set(self, red, green, blue)
    local function setFreq(pin, value)
        if value == 0 then
            pwm.stop(pin)
        else
            pwm.setduty(pin, value)
            pwm.start(pin)
        end
    end

    print(red, green, blue)

    setFreq(self.red_pin, red)
    setFreq(self.green_pin, green)
    setFreq(self.blue_pin, blue)
end

function RGBLed.setWarnLevel(self, colorLevel, brightness)
    local function toPwmValue(input) 
        local minValue = math.floor(1023 * (1 - brightness))
        return minValue + math.floor((1023 - minValue) * input)
    end

    local red = toPwmValue(1 - colorLevel) 
    local green = toPwmValue(colorLevel)

    self:set(red, green, 1023)
end
