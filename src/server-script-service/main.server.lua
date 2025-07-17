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
-- Script to handle remote event assignments and binding of functions to their respective modulescripts

-- Get the services, modules, remote events and remote functions for easy referral
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local GetFile = require(ServerScriptService["get-file"])
local HostSystem = require(ServerScriptService["host-system"])
local SharedDataModule = require(ServerScriptService["shared-data-module"])
local ShootBullet = require(ServerScriptService["shoot-bullet"])
local TeleportEvent: RemoteEvent = ReplicatedStorage:WaitForChild("TeleportEvent")
local TeleportToBox = require(ServerScriptService["teleport-to-box"])
local JoinAndLeave = require(ServerScriptService["join-and-leave"])
local ChangeBTC: RemoteEvent = ReplicatedStorage:WaitForChild("ChangeBTC")
local FTPEvent: RemoteEvent = ReplicatedStorage:WaitForChild("FTPEvent")
local ShootEvent: RemoteEvent = ReplicatedStorage:WaitForChild("ShootEvent")
local CheckPerms: RemoteFunction = ReplicatedStorage:WaitForChild("CheckPerms")
local VerifyPerms = require(ServerScriptService["verify-perms"])


TeleportEvent.OnServerEvent:Connect(function(player: Player, fileName: string, targetHostname: string)
    TeleportToBox.teleportEvent(player, fileName, targetHostname)
end)

ShootEvent.OnServerEvent:Connect(function(player: Player, targetPosition) 
    ShootBullet.shootEvent(player, targetPosition)
end)

Players.PlayerAdded:Connect(function(player)
    JoinAndLeave.playerAdded(player)
end)

Players.PlayerRejoining:Connect(function(player)
    JoinAndLeave.playerRemoved(player)
end)

-- The client isn't allowed to check if they have correct perms due to security reasons, so this is why
-- we have a remote function that does so
CheckPerms.OnServerInvoke = function(player: Player, hostname: string)
    return VerifyPerms.verifyPerms(tostring(player.UserId), hostname)
end

-- TODO: modularise this later
FTPEvent.OnServerEvent:Connect(function(player: Player)
    -- It's a toggle, so we do the opposite
    if player:GetAttribute("InFTP") then
        player:SetAttribute("InFTP", false)
        
        player.Character.Humanoid.WalkSpeed = 20 -- Revert back to normal
    else
        player:SetAttribute("InFTP", true)

        player.Character.Humanoid.WalkSpeed = 0 -- Disable moving while in FTP UI
    end
end)
