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

-- ASHES! ASHES! THEY ALL FALL DOWN.

-- Module to handle the shooting of bullets, please ignore the module name. Frank is my friend (I think) (I hope).
local module = {}
local Players = game:GetService("Players")
local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

local function isPlayerHumanoid(humanoid: Humanoid): boolean
	local character = humanoid.Parent
	if character and Players:GetPlayerFromCharacter(character) then
		return true
	end
	return false
end

local BULLET_SPEED = 150

-- Shoots a linear bullet from player to the target mouse position
function module.shootEvent(player: Player, targetPosition)
	local ball: Part = Instance.new("Part")
	ball.Shape = Enum.PartType.Ball
	ball.Size = Vector3.new(1, 1, 1)
	ball.Position = player.Character.HumanoidRootPart.Position
	ball.Parent = workspace

	local attachment = ball:FindFirstChildWhichIsA("Attachment")
	-- Linear velocity cannot work without an attachment, so we must
	-- create it if it does not exist.
	if attachment == nil then
		attachment = Instance.new("Attachment")
		attachment.Parent = ball
	end

	local linearVelocity = Instance.new("LinearVelocity")

	linearVelocity.Parent = attachment
	linearVelocity.MaxForce = math.huge
	linearVelocity.VectorVelocity = (targetPosition - ball.Position).Unit * BULLET_SPEED
	linearVelocity.Attachment0 = attachment

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
