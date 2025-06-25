local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local shootEvent: RemoteEvent = ReplicatedStorage:WaitForChild("ShootEvent")

local function isPlayerHumanoid(humanoid: Humanoid): boolean
	local character = humanoid.Parent
	if character and game.Players:GetPlayerFromCharacter(character) then
		return true
	end
	return false
end

-- bullet shoots linearly because its not actually bullets, its just simulated.
shootEvent.OnServerEvent:Connect(function(player: Player, targetPosition)
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
end)
