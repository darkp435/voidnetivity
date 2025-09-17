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

-- script to manage player data when they join and disconnects
local module = {}

local replicatedStorage: ReplicatedStorage = game:WaitForChild("ReplicatedStorage")
local welcomeEvent: RemoteEvent = replicatedStorage:WaitForChild("WelcomeEvent")
local Players = game:GetService("Players")
local ServerScriptService: ServerScriptService = game:GetService("ServerScriptService")
local datamodule = require(ServerScriptService["shared-data-module"])

-- welcome function to tell the player whats going on
-- TODO: implement this later
local function welcome(player: Player)
	welcomeEvent:FireClient(player)
end

local function humanoidDied()
	-- Give them back the tools in their backpack, and also
	-- teleport them to the appropriate host.
	-- TODO: implement this later.
end

function module.characterAdded(character: Model)
	local humanoid: Humanoid = character.Humanoid
	humanoid.Died:Connect(humanoidDied)
end

-- when the player joins, sets the attributes and gets the data stored
function module.playerAdded(player: Player)
	player.Character.Humanoid.Died:Connect()
	-- Set default attributes, to be changed later.
	player:SetAttribute("InFTP", false)
	player.Character.Humanoid.WalkSpeed = 20

	local btc = datamodule.getBtc(tostring(player.UserId))

	if btc then
		player:SetAttribute("btc", btc)		
	else
		btc = 0
		welcome(player)
	end

	replicatedStorage.ChangeBTC:FireClient(player, btc)
end

-- when a player leaves the game, save their data
function module.playerRemoved(player: Player)
	datamodule.savePlayerData(tostring(player.UserId))
end

return module
