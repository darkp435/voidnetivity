local module = {}

--- Function to give the player the file. Does NOT validate if they do have access to it.
function module.EquipFile(player: Player, file: string)
	local clonedFile: Tool

	if file == "brute.exe" then
		clonedFile = game.ServerStorage:FindFirstChild("brute.exe"):Clone()
		clonedFile.Parent = player.Backpack
	end
end

return module
