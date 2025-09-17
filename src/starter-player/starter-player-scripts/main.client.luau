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

-- Script to handle the client side events

local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Backpack: Backpack = LocalPlayer:WaitForChild("Backpack")
local WelcomeEvent: RemoteEvent = ReplicatedStorage.WelcomeEvent
local WelcomeGui = require(LocalPlayer.PlayerScripts["welcome-gui"])
local backpackAndFiles = require(LocalPlayer.PlayerScripts["backpack-and-files"])
local Attributes = require(ReplicatedStorage["attributes"])

local ScreenGui = Instance.new("ScreenGui")
-- Make sure that there is a ScreenGui always available
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local BTCCounter: TextLabel = ScreenGui:FindFirstChild("BTC")

Backpack.ChildAdded:Connect(function(child: any)
	backpackAndFiles.childAdded(child)
end)

LocalPlayer.AttributeChanged:Connect(function(attribute)
	if attribute == Attributes.btc then
		BTCCounter.Text = tostring(LocalPlayer:GetAttribute(Attributes.btc))
	end
end)

WelcomeEvent.OnClientEvent:Connect(WelcomeGui.welcomeEvent)
