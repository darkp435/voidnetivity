-- SPDX-License-Identifier: Apache-2.0
-- Copyright (c) 2025 darkp435

-- Module to implement the currency mining system when "extract.exe" is ran.
local M = {}
local ServerScriptService = game:GetService("ServerScriptService")
local Data = require(ServerScriptService.data["shared-data-module"])

function M.runFile(player: Player)
    if not string.sub(Data.getCurrentHost(player.UserId), 1, 4) == "USER" then return end
    local difficulty = tonumber(string.sub(Data.getCurrentHost(player.UserId), 5, -1))
    local processPower = 100 + (difficulty * 35)
    Data.adjustProcPower(player.UserId, processPower)
end

return M