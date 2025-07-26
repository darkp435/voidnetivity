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

-- Client side of brute force minigame
local module = {}

-- Boilerplate
local BruteForce: RemoteEvent = game:GetService("ReplicatedStorage")
local PlayerGui: PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local function minigameLoop(data: string)
    -- placeholder lol
end

-- This function should be binded by the RemoteEvent that triggers the brute force minigame.
function module.bruteForceMinigame(start: boolean, data: string)
    if start then
        -- The UI positions and size have seemingly magic numbers, but that's because it's what makes it look good.
        local frame = Instance.new("Frame")
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.Size = UDim2.new(0.25, 0, 0.25, 0)
        frame.Position = UDim2.new(0.402, 0, 0.375, 0)
        frame.Parent = PlayerGui.ScreenGui

        local prompt = Instance.new("TextLabel")
        prompt.TextColor3 = Color3.fromRGB(66, 179, 62)
        prompt.Text = "Continue with brute.exe?"
        prompt.Position = UDim2.new(0.202, 0, 0.209, 0)
        prompt.Size = UDim2.new(0.593, 0, 0.4, 0)

        local yes = Instance.new("TextButton")
        yes.Text = "Yes"
        yes.TextColor3 = Color3.fromRGB(0, 0, 0)
        yes.BackgroundColor3 = Color3.fromRGB(66, 179, 62)
        yes.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json")
        yes.Size = UDim2.new(0.057, 0, 0.746, 0)
        yes.Position = UDim2.new(0.1, 0, 0.1, 0)
        yes.BorderSizePixel = 3
        yes.BorderColor3 = Color3.fromRGB(0, 0, 0)
        yes.BackgroundColor3 = Color3.fromRGB(177, 177, 177)
        -- Just trust the process with me on this next line
        local no = yes:Clone()

        -- This function is purely for style reasons
        yes.MouseEnter:Connect(function(_, _)
            yes.BackgroundColor3 = Color3.fromRGB(111, 111, 111)
        end)

        -- Revert back to original style
        yes.MouseLeave:Connect(function(_, _)
            yes.BackgroundColor3 = Color3.fromRGB(177, 177, 177)
        end)

        no.Text = "No"
        no.Position = UDim2.new(0.624, 0, 0.746, 0)
        -- Again, for the style.
        no.MouseEnter:Connect(function(_, _)
            no.BackgroundColor3 = Color3.fromRGB(111, 111, 111)
        end)

        -- Revert back to original style.
        no.MouseLeave:Connect(function(_, _)
            no.BackgroundColor3 = Color3.fromRGB(177, 177, 177)
        end)

        yes.Parent = frame
        no.Parent = frame

        yes.MouseButton1Click:Connect(function()
            BruteForce:FireServer()
        end)

        no.MouseButton1Click:Connect(function()
            frame:Destroy()
        end)
    else
        minigameLoop(data)
    end
end

return module