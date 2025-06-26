-- script to manage player data when they join and disconnects
local replicatedStorage: ReplicatedStorage = game:WaitForChild("ReplicatedStorage")
local players: Players = game:GetService("Players")
local welcomeEvent: RemoteEvent = replicatedStorage:WaitForChild("WelcomeEvent")
local ServerScriptService: ServerScriptService = game:GetService("ServerScriptService")
local datamodule = require(ServerScriptService.SharedDataModule)

-- welcome function to tell the player whats going on
-- TODO: implement this later
local function welcome(player: Player)
	welcomeEvent:FireClient(player)
end

-- when the player joins, sets the attributes and gets the data stored
players.PlayerAdded:Connect(function(player: Player)
	local btc = datamodule.getBtc(tostring(player.UserId))
	
	if btc then
		player:SetAttribute("btc", btc)		
	else
		btc = 0
		welcome(player)
	end
	
	replicatedStorage.ChangeBTC:FireClient(player, btc)
end)

-- when a player leaves the game, save their data
players.PlayerRemoving:Connect(function(player)
	datamodule.savePlayerData(tostring(player.UserId))
end)