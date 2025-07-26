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

-- Boilerplate
local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local FTPEvent: RemoteEvent = ReplicatedStorage:WaitForChild("FTPEvent")
local CheckPerms: RemoteFunction = ReplicatedStorage:WaitForChild("CheckPerms")
local PlayerGui: PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local Promise = require(ReplicatedStorage.Packages.promise)
local module = {}

-- Default text label to be cloned, do NOT use it like a normal label, just clone it
local defaultTextLabel: TextLabel = Instance.new("TextLabel")
defaultTextLabel.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json")
defaultTextLabel.RichText = true
defaultTextLabel.TextColor3 = Color3.fromRGB(66, 179, 62)
defaultTextLabel.TextSize = 20
defaultTextLabel.BackgroundTransparency = 1
defaultTextLabel.TextXAlignment = Enum.TextXAlignment.Left
defaultTextLabel.Archivable = true

local REJECTED_LABEL_TEXT = [[
Error 401: permission denied
You do not have access to the remote host
<b>RETURN</b>, <b>SPACE</b> or <b>ALT</b> to exit
]]

local ACCEPTED_LABEL_TEXT = [[
Success - user is authenticated
Connected to remote host on port 21
]]

-- TODO: add "retry" feature
local function inputBegan(input: InputObject, gameProcessedEvent: boolean)
    if gameProcessedEvent then return end

    if input.KeyCode == Enum.KeyCode.Space or
        input.KeyCode == Enum.KeyCode.LeftAlt or
        input.KeyCode == Enum.KeyCode.RightAlt or
        input.KeyCode == Enum.KeyCode.Return or
        input.KeyCode == Enum.KeyCode.KeypadEnter -- Fail safe in case somebody tries it
    then
        return true
    else
        return false
    end
end

-- Returns true for if they have USER access, otherwise false
local function verifyPerms(enterPressed, hostInput: string)
    if enterPressed then
        local host = hostInput.Text
    end

    local hasAccess = CheckPerms:InvokeServer(hostInput)
    -- NOTE: the server **MUST** still check if the player actually has
    -- permissions to transfer files, since this is on the client side
    -- for the UI.

    if hasAccess then
        return true
    else
        return false
    end
end

-- Function to wait for user textbox inputs to keep code linear
local function waitForInput(input: TextBox)
    return Promise.new(function(resolve, _)
        input:CaptureFocus()

        input.FocusLost:Connect(function(enterPressed)
            if enterPressed then resolve(input.Text) end
        end)
    end)
end

-- The positions of the UI elements may be changed in the future
-- FIXME: UI positions
function module.FTPEVentCallback()
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
    hostInput.Text = ""
    local enteredHost = waitForInput(hostInput):await()
    local hasPerms -- Init so it's accessible

    -- TODO: refactor this spaghetti code
    -- NOTE: the above TODO will probably never happen due to the
    -- developer's habit of procrastination.
    hostInput.FocusLost:Connect(function(enterPressed)
        hasPerms = verifyPerms(enterPressed, hostInput.Text)
        local statusLabel = defaultTextLabel:Clone()
        statusLabel.Parent = frame
        statusLabel.Position = UDim2.new(0.2, 0, 0.3, 0)

        if not hasPerms then
            statusLabel.Text = REJECTED_LABEL_TEXT
            local inputCallback
            
            inputCallback = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
                local keypressed = inputBegan(input, gameProcessedEvent)
                
                if keypressed then
                    frame:Destroy()
                    inputCallback:Disconnect()
                end
            end)
        else
            statusLabel.Text = ACCEPTED_LABEL_TEXT
        end
    end)
end

return module