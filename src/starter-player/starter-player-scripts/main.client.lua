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
local LocalPlayer = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Backpack: Backpack = LocalPlayer:WaitForChild("Backpack")
local StarterQuest = require(LocalPlayer.PlayerScripts["start-quest"])
local WelcomeEvent: RemoteEvent = ReplicatedStorage.WelcomeEvent
local WelcomeGui = require(LocalPlayer.PlayerScripts["welcome-gui"])

local ScreenGui = Instance.new("ScreenGui")
-- Make sure that there is a ScreenGui always available
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

Backpack.ChildAdded:Connect(function(child: any)
    -- Connect the tools to the respective RemoteEvents
    if child:IsA("Tool") and child.Name == "StarterQuest" then
        StarterQuest.connectTool(child)
    end
end)

WelcomeEvent.OnClientEvent:Connect(WelcomeGui.welcomeEvent)
