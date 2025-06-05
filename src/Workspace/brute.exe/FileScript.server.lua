local file = script.Parent
local clickDetector = file:WaitForChild("ClickDetector")
local getFile = require(game.ServerScriptService:WaitForChild("GetFile"))

clickDetector.MouseClick:Connect(function(playerWhoClicked) 
	getFile.EquipFile(playerWhoClicked, "brute.exe")
end)