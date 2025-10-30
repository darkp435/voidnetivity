-- SPDX-License-Identifier: Apache-2.0
-- Copyright (c) 2025 darkp435

local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local HostSystem = require(ServerScriptService["data"]["hosts"])
local Data = require(ServerScriptService["data"]["shared-data-module"])

-- Module for binding NPC AI, **currently unfinished**.
local module = {}

local MAXIMUM_SEEN_DISTANCE = 5
local TARGET_DIST = 10
local RANDOM_WALK_MAX_DISTANCE = 10
local RANDOM_FORWARD_WALK_MAX_DISTANCE = 20
local NPC_CLOSE_TO_WALL_SIZE = Vector3.new(3, 1, 3)

-- Distance is flat because the y-axis is overrated
local function calcDistance(origin: Vector3, target: Vector3)
	return math.sqrt(origin.X - target.X ^ 2 + origin.Z - target.Z ^ 2)
end

-- Based on distance, not path
local function findNearestPlayerCoords(origin: Vector3, host: string): Player
	local targetList = Data.getUsersOnHost(host)
	local playerTarget: Player = nil
	local minDistance = math.huge -- I don't do math but I'm pretty sure this can't be negative

	for _, potentialTarget: Player in targetList do
		local distance = calcDistance(origin, potentialTarget.Character.HumanoidRootPart.Position)

		if distance < minDistance then
			playerTarget = potentialTarget
		end
	end

	return playerTarget
end

-- The math was done by ChatGPT because there was no way
-- in heaven or hell I was gonna learn how parametric equations
-- work and do this myself. I've tested it on Desmos and I think
-- it works.
local function getTargetCoords(a: Vector3, b: Vector3)
	
end

-- NOTE: the humanoid:MoveTo method is asynchronous!
local function chasePlayer(player: Player, npc: Model)
	local humanoid: Humanoid = npc:FindFirstChild("Humanoid")
	local pos = player.Character.HumanoidRootPart.Position
	local target = pos - Vector3.new(TARGET_DIST, 0, TARGET_DIST)
	local path = PathfindingService:CreatePath({
		AgentRadius = 3,
		AgentHeight = 5,
		AgentCanJump = true,
		WayPointSpacing = 4
	})

	path:ComputeAsync(npc:FindFirstChild("HumanoidRootPart", true), target)
	if path.Status ~= Enum.PathStatus.Success then
		humanoid:MoveTo(target)
	end

	for _, point in path:GetWaypoints() do
		humanoid:MoveTo(point)
	end
end

--- Returns true if the coordinate is valid for the NPC to walk to.
---@param targetCoords Vector3 Vector3 of the proposed coordinate.
local function isValid(targetCoords: Vector3, dimensions): boolean
	if targetCoords == nil then
		return false
	end
	-- We don't need exact precision since it's just a random position
	-- the NPC walks to so that it isn't stationary, so we use
	-- workspace:GetPartBoundsInBox instead of workspace:GetPartsInPart
	-- since it is more efficient.
	local parts = workspace:GetPartBoundsInBox(targetCoords, NPC_CLOSE_TO_WALL_SIZE)
	if parts ~= nil then
		return false
	end
	-- Outside the host
	return true
end

local function generateRandomCoords(npcPos: Vector3)
	local x = math.random(npcPos.X - RANDOM_WALK_MAX_DISTANCE, npcPos.X + RANDOM_FORWARD_WALK_MAX_DISTANCE)
	local y = math.random(npcPos.Y - RANDOM_WALK_MAX_DISTANCE, npcPos.Y + RANDOM_WALK_MAX_DISTANCE)

	-- TODO: use raycast to make walkto not flat
	return Vector3.new(x, y, npcPos.Z)
end

-- This function does exactly what the name implies
local function walkRandomly(npc: Model, host: string)
	local dimensions = HostSystem.getHostDimensions(host)
	-- We can't always generate a coordinate that is reachable from the NPC,
	-- so if the coordinate can't be reached, we simply reject it.
	local targetCoords
	local path = PathfindingService:CreatePath({
		AgentRadius = 3,
		AgentHeight = 5,
		AgentCanJump = true,
		WayPointSpacing = 4
	})

	while not isValid(targetCoords, dimensions) do
		targetCoords = generateRandomCoords(npc.HumanoidRootPart.Position)
	end

	path:ComputeAsync(npc.HumanoidRootPart.Position, targetCoords)
end

function module.bindNpcAI(npc: Model, host: string)
	-- local humanoid: Humanoid? = npc:FindFirstChildWhichIsA("Humanoid")
	local hrp: Instance? = npc:FindFirstChild("HumanoidRootPart")
	if hrp == nil then return end
	if not hrp:IsA("BasePart") then
		return
	end

	local path: Path = PathfindingService:CreatePath({
		AgentRadius = 3,
		AgentHeight = 5,
		AgentCanJump = true,
		WayPointSpacing = 5
	})

	-- The original plan was to see if the NPC is facing forwards, but after
	-- doing a bit of research, I discovered that it required linear algebra,
	-- which is miles beyond my scope and understanding of math.
	-- (Nah but seriously what the actual hell is a "euler angle")
	-- TODO: confront my fears of high level mathematics and implement it

	while npc ~= nil do
		local targetPlayer = findNearestPlayerCoords(hrp.Position, host)
		if calcDistance(targetPlayer, hrp.Position) <= MAXIMUM_SEEN_DISTANCE then
			chasePlayer(targetPlayer, npc)
		else
			walkRandomly(npc, host)
		end
	end
end

return module