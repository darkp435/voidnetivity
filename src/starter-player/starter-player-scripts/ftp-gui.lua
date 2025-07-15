-- Boilerplate
local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local FTPEvent: RemoteEvent = ReplicatedStorage:WaitForChild("FTPEvent")
local CheckPerms: RemoteFunction = ReplicatedStorage:WaitForChild("CheckPerms")
local PlayerGui: PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
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
]]

-- TODO: add "retry" feature
local function inputBegan(input: InputObject, gameProcessedEvent: boolean)
    if gameProcessedEvent then return end

    if
        input.KeyCode == Enum.KeyCode.Space or
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
    hostInput:CaptureFocus()
    local hasPerms -- Init so it's accessible

    hostInput.FocusLost:Connect(function(enterPressed)
        hasPerms = verifyPerms(enterPressed, hostInput.Text)
    end)

    if not hasPerms then
        local rejectedLabel = defaultTextLabel:Clone()
        rejectedLabel.Text = REJECTED_LABEL_TEXT
        local inputCallback
        
        inputCallback = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            local keypressed = inputBegan(input, gameProcessedEvent)
            
            if keypressed then
                frame:Destroy()
                inputCallback:Disconnect()
            end
        end)
    else
        
    end
end

return module