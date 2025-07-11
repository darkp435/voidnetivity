local module = {}
local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui: PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui

-- display the welcome gui for first time players so that they know how the game works
function module.welcomeEvent()
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Position = UDim2.new()
end

return module