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

-- Generalised algorithmic utilities. They don't use the Roblox API
local module = {}

-- Linear search function. Does **not** work on recursive tables and returns -1 if not found
function module.linearSearch(array: table, value: any): number
	for index, item in array do
		if item == value then
			return index
		end
	end

	-- Not found
	return -1
end

--- Breadth-first search helper function for shortestUnweightedPath
local function bfs(graph: table)
	-- TODO: write this dumb thing later
end

--- Finds the shortest path on an unweighted graph between two nodes.
---@param graph table Adjacency list representation of the graph
---@param source any Source node (aka origin)
---@param target any Target node (aka destination)
function module.shortestUnweightedPath(graph: table, source: any, target: any)

end

return module