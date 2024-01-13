# ESP8266 Lua/NodeMCU module for MAX44009 illuminance sensor

This repository contains an ESP8266 NodeMCU Lua module (`max44009.lua`) as well
as MQTT / HomeAssistant / InfluxDB integration example (`init.lua`) for
**MAX44009** illuminance sensors.

## Dependencies

max44009.lua has been tested with Lua 5.1 on NodeMCU firmware 3.0.1 (Release
202112300746, float build). It requires the following modules.

* bit
* i2c

Most practical applications (such as the example in init.lua) also need the
following modules.

* gpio
* mqtt
* node
* tmr
* wifi

## Setup

Connect the MAX44009 sensor to your ESP8266/NodeMCU board as follows.

* MAX44009 GND → ESP8266/NodeMCU GND
* MAX44009 VCC → ESP8266/NodeMCU 3V3
* MAX44009 SDA → NodeMCU D1 (ESP8266 GPIO5)
* MAX44009 SCL → NodeMCU D2 (ESP8266 GPIO4)

If you use different pins for SCL and SDA, you need to adjust the i2c.setup
call in the examples provided in this repository to reflect those changes. Keep
in mind that some ESP8266 pins must have well-defined logic levels at boot time
and may therefore be unsuitable for MAX44009 connection.

## Usage

Copy **max44009.lua** to your NodeMCU board and set it up as follows.

```lua
max44009 = require("max44009")
i2c.setup(0, sda_pin, scl_pin, i2c.SLOW)

-- can be called with up to 1 Hz
function some_timer_callback()
	local lx = max44009.read()
	if lx == nil then
		print("MAX44009 error")
	else
		-- lx contains the illuminance. Note that it is a floating point value.
	end
end
```

## Application Example

**init.lua** is an example application with HomeAssistant integration.
To use it, you need to create a **config.lua** file with WiFI and MQTT settings:

```lua
station_cfg = {ssid = "foo", pwd = "bar"}
mqtt_host = "..."
```

Optionally, it can also publish readings to InfluxDB.
To do so, configure URL and attribute:

```lua
influx_url = "..."
influx_attr = "..."
```

Readings will be stored as `max44009[influx_attr] illuminance_lx=...`.
So, unless `influx_attr = ''`, it must start with a comma, e.g. `influx_attr = ',device=' .. device_id`.
