--[[
 Copyright 2025 Tiger Duan

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 ]]

--[[
Module for managing the host system and abstracting it as well as fetching data about the host
Host system is represented via a graph because it aligns better with what the network looks like
]]

local module = {}

-- Host class
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

--- General function to get the host object from the hostname.
function module.getHostFromName(name: string): table
	return module[name]
end

--- Function to get the map name of the host.
function module.getMap(host: string): string
	return module[host]:getMap()
end

return module

