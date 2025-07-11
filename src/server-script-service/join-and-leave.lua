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

-- when the player joins, sets the attributes and gets the data stored
function module.playerAdded(player: Player)
	-- Set default attributes
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