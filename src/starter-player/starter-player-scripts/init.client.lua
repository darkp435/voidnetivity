local LocalPlayer = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Backpack: Backpack = LocalPlayer:WaitForChild("Backpack")
local StarterQuest = require(LocalPlayer.PlayerScripts["start-quest"])
local WelcomeEvent: RemoteEvent = ReplicatedStorage.WelcomeEvent
local WelcomeGui = require(LocalPlayer.PlayerScripts["welcome-gui"])

Backpack.ChildAdded:Connect(function(child: any)
    -- Connect the tools to the respective RemoteEvents
    if child:IsA("Tool") and child.Name == "StarterQuest" then
        StarterQuest.connectTool(child)
    end
end)

WelcomeEvent.OnClientEvent:Connect(WelcomeGui.welcomeEvent)