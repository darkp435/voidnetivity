-- script to manage player data when they join and disconnects

-- boilerplate
local replicatedStorage = game:WaitForChild("ReplicatedStorage")
local dataStoreService = game:GetService("DataStoreService")
local players = game:GetService("Players")
local dataStore = dataStoreService:GetDataStore("Data")
local welcomeEvent = replicatedStorage.WelcomeEvent

-- welcome function to tell the player whats going on
-- TODO: implement this later
local function welcome(player: Player)
	welcomeEvent:FireClient(player)
end

-- when the player joins, sets the attributes and gets the data stored
players.PlayerAdded:Connect(function(player)
	local data, _ = dataStore:GetAsync(player.UserId)
	local btc
	print(data)
	
	if data.bitcoin then
		btc = data.bitcoin
		player:SetAttribute("btc", btc)		
	else
		btc = 0
		welcome(player)
	end
	
	replicatedStorage.ChangeBTC:FireClient(player, btc)
end)

-- when a player leaves the game, save their data
players.PlayerRemoving:Connect(function(player)
	dataStore:SetAsync(tostring(player.UserId), {
		bitcoin = player:GetAttribute("btc")
	})
end)