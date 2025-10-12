-- SPDX-License-Identifier: Apache-2.0
-- Copyright (c) 2025 darkp435

local M = {}

function M.bindGunLogic(tool: Tool)
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local player = game.Players.LocalPlayer
	local mouse = player:GetMouse()
	local shootEvent = replicatedStorage:WaitForChild("ShootEvent")

	tool.Activated:Connect(function()
		local target = mouse.Hit.Position
		shootEvent:FireServer(target)
	end)
end

return M