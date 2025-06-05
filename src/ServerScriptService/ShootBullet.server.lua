local ReplicatedStorage = game:GetService("ReplicatedStorage")
local shootEvent = ReplicatedStorage:WaitForChild("ShootEvent")

local function isPlayerHumanoid(humanoid)
	local character = humanoid.Parent
	if character and game.Players:GetPlayerFromCharacter(character) then
		return true
	end
	return false
end

shootEvent.OnServerEvent:Connect(function(player, targetPosition)
	local ball = game.ServerStorage.Bullet:Clone()
	ball.Position = player.Character.HumanoidRootPart.Position
	ball.Parent = workspace

	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(5000, 5000, 5000)
	bodyVelocity.Velocity = (targetPosition - ball.Position).unit * 150
	bodyVelocity.Parent = ball

	ball.Touched:Connect(function(hit)
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if humanoid and not isPlayerHumanoid(humanoid) then
			humanoid:TakeDamage(10)
			ball:Destroy()
		end
	end)
end)
