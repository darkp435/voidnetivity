-- SPDX-License-Identifier: Apache-2.0
-- Copyright (c) 2025 darkp435

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local M = {}

local FILE_DISPLAY_FONT = Font.new("rbxasset://fonts/families/Inconsolata.json")
local EquipEvent = ReplicatedStorage:WaitForChild("Equip")

local function onClick(filename)
	EquipEvent:FireServer()
end

-- Responsible for creating a file model
function M.createFile()
	local file = Instance.new("Model")
	local clickdetector = Instance.new("ClickDetector")
	local fileModel = Instance.new("Part")
	clickdetector.Parent = fileModel
	local surfacegui = Instance.new("SurfaceGui")
	surfacegui.Parent = fileModel
	local fileLabel = Instance.new("TextLabel")
	fileLabel.FontFace = FILE_DISPLAY_FONT
	-- We discard the callback parameter because it represents
	-- the player who clicked, but since it's already being ran
	-- in a LocalScript context, the person who clicked it will
	-- always be LocalPlayer.
	clickdetector.MouseClick:Connect(function(_)
		
	end)
end

return M
