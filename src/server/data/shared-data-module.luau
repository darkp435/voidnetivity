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
local BiMap = utils.BiMap
local lsearch = utils.linearSearch

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

-- Represented in ASCII to save space, the actual ASCII character doesn't
-- really matter, which means that (for now) we have 255 symbols, one for
-- each file, and if we need more than 255 files (which is very unlikely)
-- then we will use 2 ASCII characters for them where the first one is
-- ASCII 255.
--
-- NOTES:
-- 1. The file name MUST match an existing one, otherwise it will fail.
-- 2. Start at ASCII 1 to avoid (unlikely but still may happen) issues
-- with the null character.
-- 3. The table is frozen to prevent changes that will break
-- compression.
-- 4. The table is stored here instead of file-data because compression is
-- only used in this file.
local FILE_COMPRESSION_TABLE = BiMap.new()
FILE_COMPRESSION_TABLE:insert("brute.exe", "\1")
FILE_COMPRESSION_TABLE:insert("aurora.exe", "\2")
FILE_COMPRESSION_TABLE:insert("unban.exe", "\3")
FILE_COMPRESSION_TABLE:insert("inject.exe", "\4")
FILE_COMPRESSION_TABLE:insert("compromise.exe", "\5")
FILE_COMPRESSION_TABLE:insert("cloak.exe", "\6")
FILE_COMPRESSION_TABLE:insert("hijack.exe", "\7")
FILE_COMPRESSION_TABLE:insert("mouse.exe", "\8")
FILE_COMPRESSION_TABLE:insert("root.exe", "\9")
FILE_COMPRESSION_TABLE:insert("57fe2c78-aae7-4dda-aec4-45474493f910.enc", "\10")
FILE_COMPRESSION_TABLE:insert("619bf01e-29bb-4f4c-b477-feb6886c3b6a.enc", "\11")
FILE_COMPRESSION_TABLE:insert("aa4fd3a8-64b9-4477-8859-50837e1630b6.enc", "\12")
FILE_COMPRESSION_TABLE:insert("79d56f27-596a-431f-9949-da275c37342e.enc", "\13")
FILE_COMPRESSION_TABLE:insert("65248216-02de-4874-9ea3-6999877463ae.enc", "\14")
FILE_COMPRESSION_TABLE:insert("ca7f6220-d240-4933-9e76-0720bb0d3240.enc", "\15")
FILE_COMPRESSION_TABLE:insert("c0d70845-92ba-4989-830d-c6fe29fc813a.enc", "\16")
FILE_COMPRESSION_TABLE:insert("6262d44c-8f8a-458d-83f4-b52538e92636.enc", "\17")
FILE_COMPRESSION_TABLE:insert("cf38dcd5-f180-4c49-8668-62fc3acec658.enc", "\18")
FILE_COMPRESSION_TABLE:insert("5ce17b99-c06d-428b-8526-095396cf221d.enc", "\19")
FILE_COMPRESSION_TABLE:insert("783c957a-c130-447d-8be8-c6e7e28683e8.enc", "\20")
FILE_COMPRESSION_TABLE:insert("d4655140-7920-4799-8cfb-da060b527901.enc", "\21")
FILE_COMPRESSION_TABLE:insert("1138b84a-4129-425b-9ccf-42c2f6379b0b.enc", "\22")
FILE_COMPRESSION_TABLE:insert("7c8dccd8-5057-4840-b36e-0482ced81abb.enc", "\23")
FILE_COMPRESSION_TABLE:insert("6efc8e9d-a037-4d1e-acaa-2445503cf589.enc", "\24")
FILE_COMPRESSION_TABLE:insert("pdebugger.exe", "\25")
FILE_COMPRESSION_TABLE:insert("lure.exe", "\26")
FILE_COMPRESSION_TABLE:insert("duplicate.exe", "\27")
FILE_COMPRESSION_TABLE:insert("maint.exe", "\28")
FILE_COMPRESSION_TABLE:insert("dev.exe", "\29")
FILE_COMPRESSION_TABLE:insert("sysadmin.exe", "\30")

table.freeze(FILE_COMPRESSION_TABLE)

local function stringifyFileList(filelist: {string}): string
	local compressed = ""
	for _, file in filelist do
		compressed = compressed .. FILE_COMPRESSION_TABLE:getByKey(file)
	end

	return compressed
end

local function unstringifyFileList(fileString: string)
	local fileList = {}

	for _, char in fileString:split("") do
		table.insert(fileList, FILE_COMPRESSION_TABLE:getByVal(char))
	end

	return fileList
end

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

--- Sets the max permission a player has
function module.setPerms(userid: string | number, hostname: string, perm: PermEnums.Permission)
	if type(userid) == "number" then
		userid = tostring(userid)
	end

	module.Data[userid]["hostinfo"][hostname]["permission"] = perm
end

--- Add a file to a host. Mainly used in conjunction with FTP.
function module.addFile(userid: string, hostname: string, filename: string)
	table.insert(module.Data[userid]["hostinfo"][hostname]["files"], filename)
end

--- Deletes a file from a host.
function module.deleteFile(userid: string, hostname: string, filename: string)
	local fileList = module.Data[userid]["hostinfo"][hostname]["files"]

	local indexToDelete = utils.linearSearch(fileList, filename)
	table.remove(fileList, indexToDelete)
end

--- Returns true if the user has SYSADM and vice versa.
function module.getSysadm(userid: string): boolean
	return module.Data[userid]["hasSysadm"]
end

--- Sets SYSADM
function module.setSysadm(userid: string | number, hasSysadm: boolean)
	module.Data[userid]["hasSysadm"] = hasSysadm
end

--- Returns true if it's the user's first time joining and vice versa.
function module.isFirstTimeJoining(userid: string)
	return module.Data[userid]["firstTimeJoining"]
end

--- Returns a list of daemons the user has on the home host.
function module.getDaemons(userid: string)
	return module.Data[userid]["daemons"]
end

--- Adds a daemon
function module.addDaemon(userid: string, daemonName: string)
	table.insert(module.Data[userid].daemons, daemonName)
end

--- Removes a daemon
function module.removeDaemon(userid: string, daemonName: string)
	local daemons = module.Data[userid].daemons
	local index = lsearch()
end

--- Returns true if the player has the daemon and vice versa
function module.hasDaemon(userid: string, daemonName: string)

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
	-- Compress the files
	for _, host in module.Data[userid].hostinfo do
		local files = module.Data[userid].hostinfo[host].files
		local compressed = stringifyFileList(files)
		files = compressed
	end

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
	for _, host in module.Data[userid].hostinfo do
		local compFiles = module.Data[userid].hostinfo[host].files
		local uncompressed = unstringifyFileList(compFiles)
		compFiles = uncompressed
	end

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
function module.getCurrentHost(userid: string | number): string
	if type(userid) == "number" then
		userid = tostring(userid)
	end
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

	for _, player: Player in Players:GetPlayers() do
		if player:GetAttribute("CurrentHost") == host then
			table.insert(users, player)
		end
	end

	return users
end

return module