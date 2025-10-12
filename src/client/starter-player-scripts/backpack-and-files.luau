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

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterQuest = require(LocalPlayer.PlayerScripts["start-quest"])
local bruteFile = require(LocalPlayer.PlayerScripts.files["brute-force-minigame"])
local FireGun = require(LocalPlayer.PlayerScripts["fire-gun"])

local module = {}

function module.childAdded(child: Instance)
	-- If it's not a tool, it should be ignored because it isn't important
	if not child:IsA("Tool") then return end

	local tool: Tool = child
	local toolName = tool.Name
	-- Connect the tools to the respective scripts
	if toolName == "StarterQuest" then
		StarterQuest.connectTool(tool)
	elseif toolName == "brute.exe" then
		tool.Activated:Connect(function()
			bruteFile.bruteForceMinigame(true, "")
		end)
	elseif toolName == "GUN" then
		FireGun.bindGunLogic(tool)
	end
end

return module