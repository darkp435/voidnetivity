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

-- Handles the displaying of a welcome prompt when the player first joins
local module = {}
local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui: PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui

-- display the welcome gui for first time players so that they know how the game works
function module.welcomeEvent()
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.Size = UDim2.fromScale(1, 1)
    frame.Position = UDim2.new()
end

return module
