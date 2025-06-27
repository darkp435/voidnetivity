-- Boilerplate
local BruteForce: RemoteEvent = game:GetService("ReplicatedStorage")
local PlayerGui: PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

function minigame()
    -- placeholder lol
end

-- This script should only have functionality when the RemoteEvent is activated
BruteForce.OnClientEvent:Connect(function(start: boolean, data: string)
    if start then
        local frame = Instance.new("Frame")
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.Size = UDim2.new(0.4, 0, 0.4, 0)
        frame.Position = UDim2.new(0.5, 0, 0.5, 0)
        frame.Parent = PlayerGui.ScreenGui

        local prompt = Instance.new("TextLabel")
        prompt.TextColor3 = Color3.fromRGB(66, 179, 62)
        prompt.Text = "Continue with brute.exe?"

        local yes = Instance.new("TextButton")
        yes.Text = "Yes"
        yes.TextColor3 = Color3.fromRGB(0, 0, 0)
        yes.BackgroundColor3 = Color3.fromRGB(66, 179, 62)
        yes.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json")
        yes.Size = UDim2.new(0.15, 0, 0.2, 0)
        yes.Position = UDim2.new(0.1, 0, 0.1, 0)

        -- Just trust the process with me on this next line
        local no = yes:Clone()
        no.Text = "No"
        no.Position = UDim2.new(0.9, 0, 0.9, 0)

        yes.Parent = frame
        no.Parent = frame

        yes.MouseButton1Click:Connect(function()
            BruteForce:FireServer(true)
        end)

        no.MouseButton1Click:Connect(function()
            frame:Destroy()
        end)
    else
        minigame(data)
    end
end)