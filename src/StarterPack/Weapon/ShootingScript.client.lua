local tool = script.Parent
local replicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local shootEvent = replicatedStorage:WaitForChild("ShootEvent")

tool.Activated:Connect(function() 
	local target = mouse.Hit.Position
	shootEvent:FireServer(target)
end)