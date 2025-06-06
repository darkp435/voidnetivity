--[[
module for managing the host system and abstracting it
host system is a graph due to how the connections system work
]]

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

-- hostnames will be represented via an adjacency list, then converted to objects for convenience, pseudocode:
--[[

module {
	hostname: {"edge1", "edge2", ...}
	...
}

]]

module["foo"] = Host.new("Map2", 13123, 4, 1)
module["bar"] = Host.new("Map2", 2324, 123, 4354)

-- function to get the host object from the hostname
function module.getHostFromName(name)
	return module[name]
end

return module
