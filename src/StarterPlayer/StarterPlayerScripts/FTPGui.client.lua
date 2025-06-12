local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local FTPEvent: RemoteEvent = ReplicatedStorage:WaitForChild("FTPEvent")
local CheckPerms: RemoteEvent = ReplicatedStorage:WaitForChild("CheckPerms")
local PlayerGui: PlayerGui = game.Players.LocalPlayer.PlayerGui

-- default text label to be cloned, do NOT use it like a normal label, just clone it
local defaultTextLabel: TextLabel = Instance.new("TextLabel")
defaultTextLabel.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json")
defaultTextLabel.TextColor3 = Color3.fromRGB(66, 179, 62)
defaultTextLabel.TextSize = 20
defaultTextLabel.BackgroundTransparency = 1
defaultTextLabel.TextXAlignment = Enum.TextXAlignment.Left

FTPEvent.OnClientEvent:Connect(function()
    -- frame is background
    -- initialise FTP with hello messages, auth and confirmations
    local frame = Instance.new("Frame")
    frame.Position = UDim2.new(1, 0, 1, 0)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.Parent = PlayerGui
    local title = defaultTextLabel:Clone()
    title.Text = "FTP"
    title.TextSize = 35
    title.Position = UDim2.new(0.1, 0, 0.1, 0)
    title.TextColor3 = Color3.fromRGB(235, 235, 235)
    title.Parent = frame
    local subtitle = defaultTextLabel:Clone()
    subtitle.Position = UDim2.new(0.15, 0, 0.1, 0)
    subtitle.Text = "Transfer files to remote hosts"
    subtitle.Parent = frame
    local hostPrompt = defaultTextLabel:Clone()
    hostPrompt.Text = "Remote host: "
    hostPrompt.Position = UDim2.new(0.2, 0, 0.1, 0)
    hostPrompt.Parent = frame
    local hostInput = Instance.new("TextBox")
    hostInput.Position = UDim2.new(0.2, 0, 0.25, 0)
    hostInput.Parent = frame
end)