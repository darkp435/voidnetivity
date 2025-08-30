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
Connected to remote host on port 32
]]

local ANCHOR_POINT_CENTER = Vector2.new(0.5, 0.5)
local ANCHOR_POINT_DEFAULT = Vector2.new(0, 0)

local FTP_FRAME = Instance.new("Frame")
FTP_FRAME.AnchorPoint = ANCHOR_POINT_CENTER
FTP_FRAME.Position = UDim2.fromScale(1, 1)
FTP_FRAME.Size = UDim2.fromScale(1, 1)
FTP_FRAME.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FTP_FRAME.Archivable = true

-- TODO: add "retry" feature
local function isActivationKey(input: InputObject, gameProcessedEvent: boolean)
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
local function verifyPerms(hostInput: string)
    local hasAccess = CheckPerms:InvokeServer(hostInput)
    -- NOTE: the server **MUST** still check if the player actually has
    -- permissions to transfer files, since this is on the client side
    -- for the UI.

    return hasAccess
end

-- Function to wait for user textbox inputs to keep code linear
local function waitForInput(input: TextBox)
    return Promise.new(function(resolve, _)
        input:CaptureFocus()

        input.FocusLost:Connect(function(enterPressed)
            if enterPressed then 
                resolve(input.Text)
            end
        end)
    end)
end

-- The positions of the UI elements may be changed in the future
-- FIXME: UI positions
function module.FTPEVentCallback()
    -- frame is background
    -- initialise FTP with hello messages, auth and confirmations
    local frame = FTP_FRAME:Clone()
    frame.Parent = PlayerGui
    local title = defaultTextLabel:Clone()
    title.Text = "FTP"
    title.TextSize = 35
    title.Position = UDim2.fromScale(0.1, 0.1)
    title.TextColor3 = Color3.fromRGB(235, 235, 235)
    title.Parent = frame
    local subtitle = defaultTextLabel:Clone()
    subtitle.Position = UDim2.fromScale(0.15, 0.1)
    subtitle.Text = "Transfer files to remote hosts"
    subtitle.Parent = frame
    local hostPrompt = defaultTextLabel:Clone()
    hostPrompt.Text = "Remote host: "
    hostPrompt.Position = UDim2.fromScale(0.2, 0.1)
    hostPrompt.Parent = frame
    local hostInput = Instance.new("TextBox")
    hostInput.Position = UDim2.fromScale(0.2, 0.25)
    hostInput.Parent = frame
    hostInput.Text = ""
    local enteredHost = waitForInput(hostInput):await()
    -- TODO: refactor this spaghetti code
    -- NOTE: the above TODO will probably never happen due to the
    -- developer's habit of procrastination.
    local hasPerms = verifyPerms(hostInput.Text)
    local statusLabel = defaultTextLabel:Clone()
    statusLabel.Parent = frame
    statusLabel.Position = UDim2.fromScale(0.2, 0.3)

    if not hasPerms then
        statusLabel.Text = REJECTED_LABEL_TEXT
        local inputCallback -- Make sure it's accessible in the scope
        
        inputCallback = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            local correctKeypressed = isActivationKey(input, gameProcessedEvent)
            
            if correctKeypressed then
                frame:Destroy()
                inputCallback:Disconnect()
            end
        end)
    else
        statusLabel.Text = ACCEPTED_LABEL_TEXT
    end
end

return module