local module = {}

function module.EquipFile(player: Player, file: string)
	local clonedFile: Tool
	
	if file == "brute.exe" then
		clonedFile = game.ServerStorage:FindFirstChild("brute.exe"):Clone()
		clonedFile.Parent = player.Backpack
	end
end

return module
