local module = {}

Host = {}
Host.__index = Host

function Host.new(map, x, y, z)
	local self = setmetatable({}, Host)
	self.map = map
	self.x = x
	self.y = y
	self.z = z
	return self
end

function Host:getVector3()
	return Vector3.new(self.x, self.y, self.z)
end

function Host:getCFrame()
	return CFrame.new(self.x, self.y, self.z)
end

function Host:getMap()
	return self.map
end

module["foo"] = Host.new("Map2", 13123, 4, 1)
module["bar"] = Host.new("Map2", 2324, 123, 4354)

return module
