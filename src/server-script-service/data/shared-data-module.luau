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

--* Modules required by this script MUST NOT have extra dependencies to prevent
--* circular dependencies.

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local utils = require(ServerScriptService["utils"])
local FileData = require(ServerScriptService["data"]["file-data"])
local PermEnums = require(ServerScriptService["perm-enums"])

--[[
## Shared Data Module

Centralises player data interactions. It managing player data on the server and efficiently interacting with datastores, centralised
on the server and provides a bunch of APIs. This is so that there is a consistent way to manage and change player data. This is the
**ONLY** script that should interact with datastores and DataStoreService. Also aims to prevent rate limits and handles errors around it.

Note 1: player metadata "loaded" to ensure incomplete data isn't saved to prevent data loss. Basically a fail-safe.
All functions must have a userid passed as the first argument as a STRING to prevent errors in datastores. It can and will blow up
if you pass numbers or anything else to it.

Note 2: the data is saved when the player leaves the game.
]]
-- When I wrote this, I used a pseudocode file for the data structure.
-- I then proceeded to lose said pseudocode, which means that only god knows what it looks like.
-- :sob:
local module = {}
module.Data = {} -- This is where the actual data is
local playerData = DataStoreService:GetDataStore("playerData") -- DataStore for player data

--- Checks if the user has USER access to a host. If the host doesn't exist, the user does not have access.
--- NONE privilege is for special hosts that contain core files


function module.hasAccessTo(userid: string, hostname: string): boolean
	-- Host isn't indexed by player data, AKA no permission
	if module.Data[userid]["hostinfo"][hostname] == nil then
		return false
	elseif module.Data[userid]["hostinfo"][hostname]["permission"] == "NONE" then
		return false
	elseif module.Data[userid]["hostinfo"][hostname]["permission"] == "BLACKLISTED" then
		return false
	else
		return true
	end
end

function module.setUserAccess(userid: string, hostname: string, perm: PermEnums.Permission)
	module.Data[userid]["hostinfo"][hostname]["permission"] = perm
end

--- Gets a list of files from the host
function module.getFilesFrom(userid: string, hostname: string): {string}
	return module.Data[userid]["hostinfo"][hostname]["files"]
end

--- Get the max permissions a player has
function module.getPerms(userid: string, hostname: string)
	return module.Data[userid]["hostinfo"][hostname]["permission"] or "none"
end

--- Add a file to a host. Mainly used in conjunction with FTP.
function module.addFile(userid: string, hostname: string, filename: string)
	table.insert(module.Data[userid]["hostinfo"][hostname]["files"], filename)
end

--- Deletes a file from a host.
--- If it fails, blame John
function module.deleteFile(userid: string, hostname: string, filename: string)
	local fileList = module.Data[userid]["hostinfo"][hostname]["files"]

	local indexToDelete = utils.linearSearch(fileList, filename)
	table.remove(fileList, indexToDelete)
end

--- Returns true if the user has SYSADM and vice versa.
function module.getSysadm(userid: string): boolean
	return module.Data[userid]["hasSysadm"]
end

--- Returns true if it's the user's first time joining and vice versa.
function module.isFirstTimeJoining(userid: string)
	return module.Data[userid]["firstTimeJoining"]
end

--- Returns a list of daemons the user has on the home host.
function module.getDaemons(userid: string)
	return module.Data[userid]["daemons"]
end

--- Gets the players number of bitcoins.
function module.getBtc(userid: string): number | nil
	return module.Data[userid]["btc"]
end

---  Setter for player bitcoin. It is also set as a player
---  attribute for easy referral. However, if you want to
---  change it, **DO NOT** set the player attribute directly
---  in any other piece of code other than this function.
---* Do not get the player attribute on the server side
---* to get amount of bitcoin, it is used on the client
---* only.
function module.setBtc(userid: string, amount: number)
	module.Data[userid]["btc"] = amount
	local player = Players:GetPlayerByUserId(tonumber(userid))
	player:SetAttribute("btc", amount)
end

--- Saves the player data to the datastore and does clean-up
function module.savePlayerData(userid: string)
	playerData:SetAsync(userid, module.Data[userid])
	-- Remove the userid index to free the allocated space
	module.Data[userid] = nil
end

--- Initialisation when the player joins the game for the first ever time
local function firstTimeInit(userid: string)
	module.Data[userid]["hasSysadm"] = false
end

--- Loads the user data into the module from the datastore.
function module.loadData(userid: string)
	local data = playerData:GetAsync(userid)
	module.Data[userid] = data

	if data == nil then
		firstTimeInit(userid)
	end
end

--- Returns an array of what the hosts the user has at least USER access to are.
function module.getHostsUserHasAccessTo(userid: string)
	local totalHosts = {}

	for hostname: string, _ in module.Data[userid]["hostinfo"] do
		if module.hasAccessTo(userid, hostname) then
			table.insert(totalHosts, hostname)
		end
	end

	return totalHosts
end

--- Returns the current host a player is in
function module.getCurrentHost(userid: string): string
	return module.Data[userid]["currenthost"]
end

--- Sets the current host a player is in
function module.setCurrentHost(userid: string, hostname: string)
	module.Data[userid]["currenthost"] = hostname
    local player = Players:GetPlayerByUserId(tonumber(userid))
    player:SetAttribute("CurrentHost", hostname)
end

--- Gets the total amount of users on a host
function module.getUsersOnHost(host: string)
	local users = {}

	for player: Player in Players:GetPlayers() do
		if player:GetAttribute("CurrentHost") == host then
			table.insert(users, player)
		end
	end

	return users

end

return module