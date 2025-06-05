local ftp = game:GetService("ReplicatedStorage"):WaitForChild("FTP"):Clone()

ftp.Parent = workspace
ftp.CFrame = CFrame.new(22, 0.5, 26)
ftp.SurfaceGui.TextButton.MouseButton1Click:Connect(function()
	print("hello world")
end)