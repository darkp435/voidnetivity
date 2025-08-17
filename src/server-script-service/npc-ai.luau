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

local PathfindingService = game:GetService("PathfindingService")
local ServerScriptService = game:GetService("ServerScriptService")
local HostSystem = require(ServerScriptService["host-system"])
-- Module for binding NPC AI, **currently unfinished**.
local module = {}

-- Based on distance, not path
local function findNearestPlayerCoords(origin: Vector3): Vector3
    -- TODO: deal with this later
    local targetList = HostSystem.getUsersOnHost()
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