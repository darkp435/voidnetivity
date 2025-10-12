-- SPDX-License-Identifier: Apache-2.0
-- Copyright (c) 2025 darkp435

-- Manages the state of the minigames. Note that this exists because the
-- state of minigames are shared across multiple minigame scripts to avoid
-- redundancy.
local M = {}
M.state = {}

function M.newMinigame(userid: number | string)
	if type(userid) == "number" then
		userid = tostring(userid)
	end
	M.state[userid] = {}
end

function M.delMinigame(userid: number | string)
	if type(userid) == "number" then
		userid = tostring(userid)
	end
	M.state[userid] = nil
end

function M.getMinigame(userid: number | string, key)
	if type(userid) == "number" then
		userid = tostring(userid)
	end
	return M.state[userid][key]
end

function M.setMinigame(userid: number | string, key, val)
	if type(userid) == "number" then
		userid = tostring(userid)
	end
	M.state[userid][key] = val
end

function M.isMinigameRunning(userid: number | string)
	if type(userid) == "number" then
		userid = tostring(userid)
	end
	return M.state[userid] ~= nil
end

return M