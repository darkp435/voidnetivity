local teleportToBox = game:GetService("ReplicatedStorage"):WaitForChild("TeleportEvent")

script.Parent.Activated:Connect(function()
	teleportToBox:FireServer(script.Parent.Name)
end)