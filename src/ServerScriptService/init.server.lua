-- Script to handle remote event assignments and binding of functions to their respective modulescripts

-- Get the services, modules and RemoteEvents
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