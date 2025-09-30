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
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local module = {}
local Data = require(ServerScriptService.data:WaitForChild("shared-data-module"))
local lsearch = require(ServerScriptService.utils).linearSearch

--- Function to give the player the file. Does NOT validate if they do have access to it.
function module.equipFile(player: Player, file: string)
	local userid = tostring(player.UserId)
	local currHost = Data.getCurrentHost(userid)
	local fileList = Data.getFilesFrom(userid, currHost)
	-- Prevent the user from getting the file if they don't have it (early return)
	if lsearch(file) == -1 then
		warn(`Note: user requested to get a file, but the file doesn't exist. (From {player.Name})`)
		return
	end
	local clonedFile: Tool
	clonedFile = ServerStorage:FindFirstChild("file"):Clone()
	clonedFile.Parent = player.Backpack
	clonedFile.Name = file
end

return module