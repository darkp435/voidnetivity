-- SPDX-License-Identifier: Apache-2.0
-- Copyright (c) 2025 darkp435

-- +---------------------------------------------------------+
-- | Server side implementation of the brute force minigame. |
-- | Must be called by teleport-to-server as it assumes that |
-- | the player is already in the box.                       |
-- +---------------------------------------------------------+
local ServerScriptService = game:GetService("ServerScriptService")
local M = {}
local state = require(ServerScriptService.files.state)
local data = require(ServerScriptService.data["shared-data-module"])
local Perm = require(ServerScriptService["perm-enums"])
local SHAPE_ATTRIB_PREFIX_TEXT = "__SHP_"
local SHAPES_PER_DIFFICULTY = 3
local SHAPES_PER_ROW = 5
local SHAPE_SPACING = 3
local DEFAULT_TIME_SECONDS = 300
local TIME_SCALING_PER_DIFFICULTY = 20
local SHAPE_TYPES = {
	Enum.PartType.Block,
	Enum.PartType.CornerWedge,
	Enum.PartType.Cylinder,
	Enum.PartType.Wedge
}
local SHAPE_COLORS = {
	Color3.fromRGB(255, 238, 0),
	Color3.fromRGB(0, 255, 0),
	Color3.fromRGB(255, 0, 0),
	Color3.fromRGB(0, 247, 255),
	Color3.fromRGB(255, 0, 251),
	Color3.fromRGB(255, 255, 255),
	Color3.fromRGB(0, 26, 255),
	Color3.fromRGB(0, 255, 132),
	Color3.fromRGB(255, 128, 0),
	Color3.fromRGB(166, 0, 255),
}

local PUNISHMENTS = {
	"SEPARATION",
	"KILLBRICK",
	"EXPLODE",
	"ENEMIES",
	"LOSETIME"
}

local function sep()

end

local function spawnKillbrick()

end

-- "Perfectly balanced"
local function explode()
	
end

local function incorrect(player: Player, box: Model, difficulty: number)
	local punishment = PUNISHMENTS[math.random(1, #PUNISHMENTS)]
end

local function correct(player: Player, box: Model)
	local userid = player.UserId
	local host = state.getMinigame(userid, "thost")
	data.setUserAccess(userid, host, Perm.User)
end

-- Function that should be binded to the clickdetector.
local function insertPart(playerWhoClicked: Player, box: Model, difficulty)
	local backpack = playerWhoClicked:FindFirstChild("Backpack")
	local userid = playerWhoClicked.UserId
	local partToTry: string = state.getMinigame(userid, "eshape")
	if not partToTry then
		warn("part to try is nil (from bgame)")
	end

	if partToTry == state.getMinigame("cshape") then
		correct(playerWhoClicked, box)
	else
		incorrect(playerWhoClicked, box, difficulty)
	end
end

local function createShape(name: string): Part
	local shape = Instance.new("Part")
	shape.CanCollide = false
	local shapeType = SHAPE_TYPES[math.random(1, #SHAPE_TYPES)]
	shape.Shape = shapeType
	shape.Anchored = true
	-- Cool glowing effect
	shape.Material = Enum.Material.Neon
	shape.Name = name
	shape.Color = SHAPE_COLORS[math.random(1, #SHAPE_COLORS)]
	return shape
end

function M.init(player: Player, box: Model, difficulty: number, host: string)
	-- Multiple instances can't be running for obvious reasons, we
	-- return to stop another instance from opening up and causing
	-- issues.
	local userid = player.UserId
	if state.isMinigameRunning(userid) then
		warn(`Minigame for player {player.Name} already running, ignored.`)
		return
	end

	state.newMinigame(userid)
	state.setMinigame(userid, "thost", host)
	local shapes = difficulty * SHAPES_PER_DIFFICULTY + math.random(1, difficulty)
	local shapeList = {}
	for i = 1, shapes, 1 do
		local shape = createShape(SHAPE_ATTRIB_PREFIX_TEXT .. i)
		table.insert(shapeList, shape)
	end
	state.setMinigame(userid, "shapes", shapeList)
	-- Correct shape
	state.setMinigame(userid, "cshape", SHAPE_ATTRIB_PREFIX_TEXT .. math.random(1, shapes))

	-- TODO: evaluate dimensions for shape insertion
	local insertBox = Instance.new("Part")
	local clickdetector = Instance.new("ClickDetector")
	clickdetector.MouseClick:Connect(function(playerWhoClicked)
		insertPart(playerWhoClicked, box, difficulty)
	end)

	-- End it with the timer as it yields.
	state.setMinigame(userid, "timer", DEFAULT_TIME_SECONDS - (difficulty * TIME_SCALING_PER_DIFFICULTY))
	while state.getMinigame("timer") > 0 do
		task.wait(1)
		state.setMinigame("timer", state.getMinigame("timer") - 1)
	end
end

return M