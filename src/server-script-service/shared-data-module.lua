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

local DataStoreService = game:GetService("DataStoreService")
--[[
SharedDataModule
================

Centralises player data interactions. It managing player data on the server and efficiently interacting with datastores, centralised
on the server and provides a bunch of APIs. This is so that there is a consistent way to manage and change player data. This is the
**ONLY** script that should interact with datastores and DataStoreService. Also aims to prevent rate limits and handles errors around it.

Note: player metadata "loaded" to ensure incomplete data isn't saved to prevent data loss. Basically a fail-safe.
All functions must have a userid passed as the first argument as a STRING to prevent errors in datastores. It can and will blow up
if you pass numbers or anything else to it.
]]

-- When I wrote this, I used a pseudocode file for the data structure.
-- I then proceeded to lose said pseudocode, which means that only god knows what it looks like.
-- :sob:

local module = {}
module.Data = {} -- This is where the actual data is
local playerData = DataStoreService:GetDataStore("playerData") -- DataStore for player data

--- Checks if the user has USER access to a host. If the host doesn't exist, the user does not have access.
function module.hasAccessTo(userid: string, hostname: string): boolean
	if module.Data[userid]["hostinfo"][hostname] == nil then
		return false
	elseif module.Data[userid]["hostinfo"][hostname]["permission"] == "none" then
		return false
	else
		return true
	end
end

--- Gets a list of files from the host
function module.getFilesFrom(userid: string, hostname: string)
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

-- Linear search function for unordered list
local function search(array: table, value: any): number
	for index, item in array do
		if item == value then
			return index
		end
	end

	-- Not found
	return -1
end

--- Deletes a file from a host.
--- If it fails, blame John
function module.deleteFile(userid: string, hostname: string, filename: string)
	local fileList = module.Data[userid]["hostinfo"][hostname]["files"]
	
	local indexToDelete = search(fileList, filename)
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

--- Saves the player data to the datastore.
function module.savePlayerData(userid: string): nil
	playerData:SetAsync(userid, module.Data[userid])
end

--- Loads the user data into the module from the datastore.
function module.loadData(userid: string): nil
	local data = playerData:GetAsync(userid)
	module.Data[userid] = data
end

return module
