--[[
 Copyright 2025 Tiger Duan

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

-- ASHES! ASHES! THEY ALL FALL DOWN.

local module = {}
local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local function isPlayerHumanoid(humanoid: Humanoid): boolean
	local character = humanoid.Parent
	if character and game.Players:GetPlayerFromCharacter(character) then
		return true
	end
	return false
end

-- Shoots a linear bullet from player to the target mouse position
function module.shootEvent(player: Player, targetPosition)
	-- clone the bullet model from serverstorage
	local ball = game.ServerStorage.Bullet:Clone()
	ball.Position = player.Character.HumanoidRootPart.Position
	ball.Parent = workspace

	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(5000, 5000, 5000)
	bodyVelocity.Velocity = (targetPosition - ball.Position).Unit * 150
	bodyVelocity.Parent = ball

	ball.Touched:Connect(function(hit)
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if humanoid and not isPlayerHumanoid(humanoid) then
			humanoid:TakeDamage(10)
			ball:Destroy()
		end
	end)

	-- destroy the bullet after 10 seconds if it has not hit anything
	task.wait(10)
	if ball then
		ball:Destroy()
	end
end

return module
