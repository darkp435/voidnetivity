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
local MessagingService = game:GetService("MessagingService")
local Players = game:GetService("Players")
local ServerScriptService: ServerScriptService = game:GetService("ServerScriptService")
local datamodule = require(ServerScriptService["data"]["shared-data-module"])

-- welcome function to tell the player whats going on
-- TODO: implement this later
local function welcome(player: Player)
	welcomeEvent:FireClient(player)
end

local function humanoidDied(player: Player)
	local backpack = player:FindFirstChild("Backpack")
end

function module.characterAdded(character: Model)
	local humanoid: Humanoid? = character:FindFirstChildWhichIsA("Humanoid")
	local player = Players:GetPlayerFromCharacter(character)

	if not humanoid then return end
	humanoid.Died:Connect(function()
		humanoidDied(player)
	end)
	player.Character.Humanoid.WalkSpeed = 20
end

-- when the player joins, sets the attributes and gets the data stored
function module.playerAdded(player: Player)
	-- Set default attributes, to be changed later.
	player:SetAttribute("InFTP", false)

	local btc = datamodule.getBtc(tostring(player.UserId))

	-- TODO: replace this
	if btc then
		player:SetAttribute("btc", btc)
	else
		btc = 0
		welcome(player)
	end
end

-- when a player leaves the game, save their data
function module.playerRemoved(player: Player)
	datamodule.savePlayerData(tostring(player.UserId))
end

return module
