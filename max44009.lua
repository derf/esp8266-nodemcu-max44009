local max44009 = {}
local device_address = 0x4a

max44009.bus_id = 0

function max44009.read()
	i2c.start(max44009.bus_id)
	if not i2c.address(max44009.bus_id, device_address, i2c.TRANSMITTER) then
		return
	end
	i2c.write(max44009.bus_id, {0x03, 0x04})
	i2c.stop(max44009.bus_id)
	i2c.start(max44009.bus_id)
	if not i2c.address(max44009.bus_id, device_address, i2c.RECEIVER) then
		return
	end
	local data = i2c.read(max44009.bus_id, 2)
	i2c.stop(max44009.bus_id)
	local mantissa = bit.lshift(bit.band(string.byte(data, 1), 0x0f), 4) + bit.band(string.byte(data, 2), 0x0f)
	local exponent = bit.rshift(bit.band(string.byte(data, 1), 0xf0), 4)
	return bit.lshift(1, exponent) * mantissa * 0.045
end

return max44009
