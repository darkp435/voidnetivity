-- Roblox Lua Script: Smooth Pathfinding to a Moving Target
-- This script demonstrates how to dynamically pathfind to a sporadically moving object
--[[
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")

-- Configure your NPC and target
local NPC = workspace.NPC -- Replace with your NPC model
local Target = game.Players:FindFirstChildOfClass("Player").Character -- Replace with your target model
local Humanoid = NPC:WaitForChild("Humanoid")
local RootPart = NPC:WaitForChild("HumanoidRootPart")

-- Pathing parameters
local REPATH_INTERVAL = 0.5      -- Seconds between full path recalculations
local WAYPOINT_THRESHOLD = 2     -- Distance at which to consider waypoint reached

-- Internal state
local currentPath = nil
local currentWaypoints = {}
local waypointIndex = 1
local lastRepathTime = 0

-- Smooth movement using MoveTo
local function moveToWaypoint(waypoint)
	if Humanoid.MoveToFinished then
		Humanoid:MoveTo(waypoint.Position)
	end
end

-- Calculate a new path to the target
local function recalculatePath()
	if currentPath then
		currentPath:Destroy()
	end
	currentPath = PathfindingService:CreatePath({
		AgentRadius = Humanoid.HipWidth.Value or 2,
		AgentHeight = Humanoid.HipHeight.Value or 5,
		AgentCanJump = true,
		AgentJumpHeight = 7,
		AgentMaxSlope = 45,
	})
	currentPath:ComputeAsync(RootPart.Position, Target.PrimaryPart.Position)

	if currentPath.Status == Enum.PathStatus.Success then
		currentWaypoints = currentPath:GetWaypoints()
		waypointIndex = 1
		moveToWaypoint(currentWaypoints[waypointIndex])
	else
		warn("Path computation failed: ", currentPath.Status)
	end
end

-- Main update loop
RunService.Heartbeat:Connect(function(deltaTime)
	local now = tick()

	-- Repath periodically to handle target movement
	if now - lastRepathTime > REPATH_INTERVAL then
		recalculatePath()
		lastRepathTime = now
	end

	-- Advance to next waypoint if close enough
	if currentWaypoints[waypointIndex] then
		local waypointPos = currentWaypoints[waypointIndex].Position
		if (RootPart.Position - waypointPos).Magnitude < WAYPOINT_THRESHOLD then
			waypointIndex = waypointIndex + 1
			if currentWaypoints[waypointIndex] then
				moveToWaypoint(currentWaypoints[waypointIndex])
			end
		end
	end
end)

-- Handle MoveToFinished to smooth out
Humanoid.MoveToFinished:Connect(function(reached)
	if reached then
		-- Directly start moving to next waypoint if one exists
		if currentWaypoints[waypointIndex] then
			moveToWaypoint(currentWaypoints[waypointIndex])
		end
	else
		-- If failed to reach, recalculate path immediately
		recalculatePath()
	end
end)

-- Optional: Visual debugging
local function drawPath()
	if currentWaypoints then
		for i = 1, #currentWaypoints - 1 do
			local a = currentWaypoints[i].Position
			local b = currentWaypoints[i + 1].Position
			local part = Instance.new("Part")
			part.Anchored = true
			part.CanCollide = false
			part.Size = Vector3.new(0.2, 0.2, (a - b).Magnitude)
			part.CFrame = CFrame.new((a + b) / 2, a)
			part.BrickColor = BrickColor.new("Bright green")
			part.Parent = workspace
			game:GetService("Debris"):AddItem(part, REPATH_INTERVAL)
		end
	end
end

-- Extend recalculatePath to include debugging
local oldRecalculate = recalculatePath
recalculatePath = function()
	oldRecalculate()
	drawPath()
end
]]