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
-- Module for the box system and file minigames

local module = {}
-- boilerplate
local serverStorage: ServerStorage = game:GetService("ServerStorage")
local serverScriptService: ServerScriptService = game:GetService("ServerScriptService")
local hostSystem: table = require(serverScriptService["host-system"])

local box = workspace.Union:Clone()

local function bruteForceMinigame(): nil
	-- placeholder function to get it working, will add minigame later
	-- true means that the user has successfully completed it and vice versa
	task.wait(5)
end

local function scriptMinigame(): nil
	
end

-- TODO: add more minigames later

local function activateMinigame(fileName: string)
	if fileName == "brute.exe" then
		bruteForceMinigame()
	elseif fileName == "script.exe" then
		scriptMinigame()
	end
end

local function teleportPlayerToHost(player: Player, hostname: string)
	player.Character.HumanoidRootPart.CFrame = hostSystem[hostname]:getCFrame()
end

local function createHost(player: Player, hostname: string)
	local hostMap = serverStorage:FindFirstChild(hostSystem[hostname]:getMap())
	hostMap.Position = hostSystem[hostname]:getVector3()
	teleportPlayerToHost(player, hostname)
end

-- Function for when the teleport RemoteEvent is fired
function module.teleportEvent(player: Player, fileName: string, targetHostname: string)
	local coords = CFrame.new(math.random(1, 10000), 1000, math.random(1, 10000))
	local file = player.Backpack:FindFirstChild(fileName)
	
	if player and file and file:IsA("Tool") then
		box.CFrame = coords
		box.Parent = workspace
		local humanoid = player.Character:WaitForChild("Humanoid")
		local hrp = player.Character:WaitForChild("HumanoidRootPart")
		if humanoid and hrp then
			hrp.CFrame = coords
			local success = activateMinigame(fileName)
			
			if success then
				if not workspace:FindFirstChild(targetHostname) then
					createHost(player, targetHostname)
				else
					teleportPlayerToHost(player, targetHostname)
				end
			end
		else
			error("Error: humanoid or HumanoidRootPart does not exist.")
		end
	else
		error("Error: file or player does not exist.")
	end
end

return module
