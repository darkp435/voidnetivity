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

-- Algorithmic utilies that multiple scripts need. If only one script needs it,
-- don't put it in here.
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

return module