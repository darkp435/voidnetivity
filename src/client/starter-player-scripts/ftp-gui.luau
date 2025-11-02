-- SPDX-License-Identifier: Apache-2.0
-- Copyright (c) 2025 darkp435

-- Boilerplate
local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local FTPFunction: RemoteFunction = ReplicatedStorage:WaitForChild("TransferFile")
local CheckPerms: RemoteFunction = ReplicatedStorage:WaitForChild("CheckPerms")
local FTPEnum = require(ReplicatedStorage:WaitForChild("ftp-status-codes"))
local StatusCode = FTPEnum.FtpStatus
local Methods = FTPEnum.Methods
local PlayerGui: PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local Promise = require(ReplicatedStorage.Packages.promise)
local M = {}

-- Default text label to be cloned, do NOT use it like a normal label, just clone it
local defaultTextLabel: TextLabel = Instance.new("TextLabel")
defaultTextLabel.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json")
defaultTextLabel.RichText = true
defaultTextLabel.TextColor3 = Color3.fromRGB(66, 179, 62)
defaultTextLabel.TextSize = 20
defaultTextLabel.BackgroundTransparency = 1
defaultTextLabel.TextXAlignment = Enum.TextXAlignment.Left
defaultTextLabel.Archivable = true

-- Frame name is UUID because it's an identifier and must not collide.
local FRAME_NAME = "ce2a182f-0a7c-47b8-bbe6-2c88dbc9d781"

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

-- TODO: implement UIs for all of these functions

local function putFile()
	local fileInputBox = Instance.new("TextBox")
	fileInputBox.Text = ""
	-- There's no reject function, so the promise can only resolve, therefore the
	-- first value returned will always be true, so we discard it.
	local _, inputVal: string = waitForInput(fileInputBox):await()
	local response: FTPEnum.Response = FTPFunction:InvokeServer(Methods.Put, inputVal)
	while response.Status == StatusCode.Pending do
		-- TODO: implement the loading bar
		response = FTPFunction:InvokeServer(Methods.Put, inputVal)
	end

	local status = response.Status
	-- TODO: implement response UI
	if status == StatusCode.BrokenPipe then
		print("Broken Pipe")
	elseif status == StatusCode.TooManyRequests then
		print("Too many requests")
	elseif status == StatusCode.Success then
		print("File transferred")
	end
end

local function getFile()
	local fileInputBox = Instance.new("TextBox")
	fileInputBox.Text = ""

	local _, inputVal = waitForInput(fileInputBox):await()
	local response: FTPEnum.Response = FTPFunction:InvokeServer(Methods.Get, inputVal)

	while response.Status == StatusCode.Pending do
		response = FTPFunction:InvokeServer(Methods.Put, inputVal)
	end

	local status = response.Status
end

local function listHomeFiles()

end

local function listRemoteFiles()

end

-- The positions of the UI elements may be changed in the future
-- FIXME: UI positions
function M.FTPEVentCallback()
	-- Ah.
	-- Roblox GUI development.
	--
	-- The Roblox GUI API makes HTML, CSS, and JavaScript look like
	-- biblical angels, and any experienced web developer knows what
	-- I'm talking about and is likely shivering.
	--
	-- The Roblox GUI API is the pinnacle of frustration and sleepless
	-- nights wondering why when you set the UDim2 of something AND
	-- the Vector2 as center, it is still not in the center. What
	-- devilish being thought that it would be a good idea for that
	-- to happen? I want to be writing CODE, not dealing with
	-- a misaligned TextLabel that shouldn't, in principle,
	-- be misaligned! What misfortune is this!?!? The event of
	-- a GUI element being fit into position perfectly programmatically
	-- without having to make adjustments in the code is certainly a
	-- divine stroke of luck, luckier than a royal flush in Texas Hold'em,
	-- luckier than winning the lottery.
	--
	-- When I place a TextLabel and set some text, unlike HTML <div>
	-- where it is (slightly) predictable, Roblox decides to truncate
	-- the text so half of the text is just gone. It's a chaotic world,
	-- yes, but for an API designed so people can easily build games...
	-- is... certainly *interesting*. This may be a rite of passage
	-- that I am going through, but I cannot deny that this obstacle
	-- is far too great for my sanity. I attempted many solutions,
	-- and they heeded naught but a slight breeze. Even if I offer
	-- a blood sacrifice and a sacred ritual, it would be the
	-- pointless, like questioning how many angels can dance on the
	-- top of a pin. It is worse, I daresay, than even the Win32 API
	-- that has droven many to insanity in search for a painless
	-- alternative. That last sentence may be a hyperbole, but it
	-- certainly increases the potency of the annoyance that this
	-- API has bestowed upon me.
	--
	-- The documentation... I swear, the people who wrote it were
	-- probably required to make it as ambiguous as possible and it's
	-- so technical that it requires a PhD in computer science and
	-- linguistics to decipher that ancient scripture. The information,
	-- or, lack thereof, is unpleasant. It may be even considered
	-- witchcraft, for it is cursed, for it has claimed the sanity
	-- of me. There will be no hope for my sanity after this, except,
	-- as a last resort, watching tutorials of people who have passed
	-- this malevolent trial and spreading the teachings of Roblox GUI
	-- programming. Sanity loss is inevitable, and likely cannot be
	-- negated, because of this god-forsaken (note: Forsaken is one
	-- of the popular games that passed this cumbersome trial of GUIs
	-- and is what I play when I don't want to be dealing with this
	-- treacherous interface) API.
	--
	-- Expect the unexpected here, for there be chaos and uncertainty
	-- below. Do not come with hope, as there is none. This is going
	-- to be a wild ride attempting to get this to work. There is no
	-- cure. All there is forward is suffering.
	--
	--* Summary: expect quirks and inconsistencies, and that some
	--* text may truncate unexpectedly.

	-- frame is background
	-- initialise FTP with hello messages, auth and confirmations
	local frame = FTP_FRAME:Clone()
	frame.Name = FRAME_NAME
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
	-- It would be great if this was refactored. However, that may
	-- never happen...
	local hasPerms = verifyPerms(hostInput.Text)
	local statusLabel = defaultTextLabel:Clone()
	statusLabel.Parent = frame
	statusLabel.Position = UDim2.fromScale(0.2, 0.3)

	-- TODO: refactor this block
	if not hasPerms then
		statusLabel.Text = REJECTED_LABEL_TEXT
		local inputCallback -- Make sure it's accessible in the scope
		
		inputCallback = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
			local correctKeypressed = isActivationKey(input, gameProcessedEvent)
			
			if correctKeypressed then
				-- Clean-up
				frame:Destroy()
				inputCallback:Disconnect()
				return
			end
		end)
	end

	statusLabel.Text = ACCEPTED_LABEL_TEXT

	-- TODO: figure out button positions
	local putButton = Instance.new("TextButton")
	local getButton = Instance.new("TextButton")
	local listHomeButton = Instance.new("TextButton")
	local listRemoteButton = Instance.new("TextButton")
	putButton.MouseButton1Click:Connect(putFile)
	getButton.MouseButton1Click:Connect(getFile)
	listHomeButton.MouseButton1Click:Connect(listHomeFiles)
	listRemoteButton.MouseButton1Click:Connect(listRemoteFiles)
end

return M