--[[
 Copyright 2025 darkp435

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

-- Generalised algorithmic utilities. They don't use the Roblox API nor any other
-- module scripts.
local module = {}

-- Linear search function. Does **not** work on recursive tables and returns -1 if not found.
function module.linearSearch(array, value: any): number
	for index, item in array do
		if item == value then
			return index
		end
	end

	-- Not found
	return -1
end

--- Finds the shortest path on an unweighted graph between two nodes.
--- Btw I have no clue how this works since this is quite literally
--- Google level algorithms and data structures, but I wouldn't touch
--- it if I were you. It works (I think (I hope (I seriously hope))).
---@param graph table Adjacency list representation of the graph
---@param source any Source node (aka origin)
---@param target any Target node (aka destination)
function module.shortestUnweightedPath(graph, source, target)
	local queue = {source}
	local par = {}
	local visited = {}
	visited[source] = true

	while #queue > 0 do
		local node = table.remove(queue, 1)
		if node == target then
			break
		end
		for _, neighbor in ipairs(graph[node]) do
			if not visited[neighbor] then
				visited[neighbor] = true
				par[neighbor] = node
				table.insert(queue, neighbor)
			end
		end
	end

	local path = {}
	local node = target
	while node do
		table.insert(path, 1, node)
		node = par[node]
	end

	if path[1] ~= source then
		return nil
	end

	return path
end

-- Bidirectional map implementation
module.BiMap = {}
module.BiMap.__index = module.BiMap

function module.BiMap.new()
	local self = setmetatable({}, module.BiMap)
	self.keyToVal = {}
	self.valToKey = {}
	return self
end

function module.BiMap:insert(key, value)
	self.keyToVal[key] = value
	self.valToKey[value] = key
end

function module.BiMap:getByKey(key)
	return self.keyToVal[key]
end

function module.BiMap:getByVal(value)
	return self.valToKey[value]
end

return module