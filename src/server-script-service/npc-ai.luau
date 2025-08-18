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

local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local HostSystem = require(ServerScriptService["host-system"])
-- Module for binding NPC AI, **currently unfinished**.
local module = {}

-- Distance is flat because the y-axis is overrated
local function calcDistance(origin: Vector3, target: Vector3)
    return math.sqrt(math.pow(origin.X - target.X, 2) + math.pow(origin.Z - target.Z, 2))
end

-- Based on distance, not path
local function findNearestPlayerCoords(origin: Vector3): Vector3
    local targetList = HostSystem.getUsersOnHost()
    local playerTarget: Player = nil
    local minDistance = math.huge -- I don't do math but I'm pretty sure this can't be negative

    for potentialTarget: Player in targetList do
        local distance = calcDistance(origin, potentialTarget.Character.HumanoidRootPart.Position)

        if distance < minDistance then
            playerTarget = potentialTarget
        end
    end

    return playerTarget.Character.HumanoidRootPart.Position
end

function module.bindNpcAI(npc: Model)
    local humanoid: Humanoid = npc:FindFirstChild("Humanoid")
    local hrp: BasePart = npc:FindFirstChild("HumanoidRootPart")

    local path: Path = PathfindingService:CreatePath({
        AgentRadius = 3,
        AgentHeight = 5,
        AgentCanJump = true,
        WayPointSpacing = 5
    })

    local target = findNearestPlayerCoords(hrp.Position)
end

return module