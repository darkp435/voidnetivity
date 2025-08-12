local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
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

-- NOTE: do not use this directly, clone it
local storedNPC: Instance = ServerStorage:WaitForChild("NPC")
local npcAIEvent: BindableEvent = ServerScriptService.npcAIEvent

-- Module responsible for spawning NPCs, it does **NOT** manage the AI for it
local module = {}

function module.spawnNPC(NPCType: string, weapon: string, pos: Vector3)
    local npc = storedNPC:Clone()
    local humanoid: Humanoid = npc:FindFirstChild("Humanoid")
    local hrp: BasePart = npc:FindFirstChild("HumanoidRootPart", true)

    -- Luau doesn't have switch case, so we have to do if-statements
    -- I hope they will support it in the future
    if NPCType == "ROOT" then
        -- The player is kinda screwed if this happens because it's one of the strongest enemies,
        -- so uh... yeah
        -- This is the one time where the player suffers more than the devs, and I'm all for it
        humanoid.MaxHealth = 2000
        humanoid.Health = 2000
    elseif NPCType == "ADMIN" then
        humanoid.MaxHealth = 500
        humanoid.Health = 500
    elseif NPCType == "DEVELOPER" then
        humanoid.MaxHealth = 250
        humanoid.Health = 250
    elseif NPCType == "MAINTAINER" then
        humanoid.MaxHealth = 150
        humanoid.Health = 150
    elseif NPCType == "USER" then
        -- Regular enemy
        humanoid.MaxHealth = 100
        humanoid.Health = 100
    elseif NPCType == "GUEST" then
        -- Weak ones reserved for starter hosts
        humanoid.MaxHealth = 75
        humanoid.Health = 75
    end

    npcAIEvent:Fire(npc)

    hrp.Parent = workspace
    hrp.Position = pos
end

return module