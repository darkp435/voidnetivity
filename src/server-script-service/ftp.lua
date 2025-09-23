-- SPDX-License-Identifier: Apache-2.0
-- Copyright (c) 2025 darkp435

-- To learn recursion, look at the bottom comment of this file

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local FtpEnum = require(ReplicatedStorage:WaitForChild("ftp-status-codes"))
local Data = require(ServerScriptService.data["shared-data-module"])
local FileData = require(ServerScriptService.data["file-data"])
local FtpMethod = FtpEnum.Methods
local FtpStatus = FtpEnum.FtpStatus
local IS_FTP_RUNNING_ATTRIBUTE = "FtpRunning"
local BROKEN_PIPE_CHANCE_THRESHOLD = 1
local UPDATE_TIME_SECONDS = 2
-- Per UPDATE_TIME_SECONDS
local LOWER_TRANSFER_SPEED = 10_000_000_000
local UPPER_TRANSFER_SPEED = 25_000_000_000

--[[
File Transfer Protocol (FTP)

While a player is in FTP, NPCs should be more aware of the player (this gives
an element of risk to starting FTP)
]]
local M = {}

-- FTP state does not get saved when they rejoin, so we don't query shared-data-module, and instead
-- put the state here
local FTPState = {}

local function exitFTP(player: Player)
	if FTPState[player.UserId] == nil then
		warn(`Request ignored: got "exit" FTP method, but player doesn't have FTP running. (From {player.Name})`)
		return {Status = FtpStatus.UnknownError}
	end

	FTPState[player.UserId] = nil
	return {Status = FtpStatus.Success}
end

local function transferFile(player: Player, file: string, host: string)
	-- Processing is a debounce to prevent multiple instances
	-- of the remote function being called and FTP processing it
	-- all at once instead of sequentially, preventing FTP
	-- instantly transferring files.
	if FTPState[player.UserId].BytesLeft == nil then
		FTPState[player.UserId].BytesLeft = FileData.fileTable[file].filesize
	elseif FTPState[player.UserId]["Processing"] then
		return {
			Status = FtpStatus.TooManyRequests
		}
	end

	FTPState[player.UserId]["Processing"] = true

	task.wait(UPDATE_TIME_SECONDS)
	if math.random(1, 100) <= BROKEN_PIPE_CHANCE_THRESHOLD then
		-- Remove entry since file is no longer being transferred
		-- to free space.
		FTPState[player.UserId].Processing = nil
		FTPState[player.UserId].BytesLeft = nil
		return {
			Status = FtpStatus.BrokenPipe
		}
	end

	local transferredBytes = math.random(LOWER_TRANSFER_SPEED, UPPER_TRANSFER_SPEED)
	FTPState[player.UserId].BytesLeft -= transferredBytes

	-- Has the file finished transferring?
	if FTPState[player.UserId].BytesLeft >= 0 then
		FTPState[player.UserId].Processing = false
		return {
			Status = FtpStatus.Pending,
			Progress = FTPState[player.UserId].BytesLeft
		}
	end

	-- Finish transfer, clean-up of data during transfer.
	FTPState[player.UserId].Processing = nil
	FTPState[player.UserId].BytesLeft = nil

	Data.addFile(tostring(player.UserId), host, file)
	return {Status = FtpStatus.Success}
end

local function getFile(player: Player, file: string)
	local userid = tostring(player.UserId)
	return transferFile(player, file, Data.getCurrentHost(userid))
end

local function putFile(player: Player, file: string)
	return transferFile(player, file, FTPState[player.UserId].TargetHost)
end

local function listFiles(player: Player)
	-- UserId must be string to pass to Data functions
	local userid = tostring(player.UserId)
	local host = Data.getCurrentHost(userid)
	local files = Data.getFilesFrom(userid, host)

	return {
		Status = FtpStatus.Success,
		FileList = files
	}
end

local function openFTP(player: Player)
	if FTPState[player.UserId] ~= nil then
		warn(`Request ignored: got "open" FTP method, but player already has FTP running. (From {player.Name})`)
		return {Status = FtpStatus.UnknownError}
	end

	FTPState[player.UserId] = {}
	return {Status = FtpStatus.Success}
end

local function listRemote(player: Player)
	local userid = tostring(player.UserId)
	local fileList = Data.getFilesFrom(userid, FTPState[player.UserId].TargetHost)
	return {
		Status = FtpStatus.Success,
		FileList = fileList
	}
end

local function changeHost(player: Player, host: string)
	if not Data.hasAccessTo(host) then
		return {Status = FtpStatus.PermDenied}
	end

	FTPState[player.UserId]["TargetHost"] = host
	return {Status = FtpStatus.Success}
end

--- Remote function. Returns a table with these properties:
--- `Status`: the status of the request
--- `FileList?`: when sending a put request, returns the list of files
---@param player Player The player who sent the request.
---@param method string The FTP request method.
---@param data string The file or the host, optional if the request is not get, put or switching hosts.
function M.ftpEvent(player: Player, method: string, data: string?): {Status: string, FileList: {string}?, Progress: number?}
	if method == FtpMethod.Open then
		openFTP(player)
	end

	-- Error, FTP is not open
	if FTPState[player.UserId] == nil then
		print()
	end

	-- Returns that has only one value must still wrap it in curly braces since we return a table, not
	-- a singular value.
	if method == FtpMethod.Exit then
		return exitFTP(player)
	elseif method == FtpMethod.Get and data == nil then
		warn(`Request ignored: the FTP method was "get", but a file wasn't provided. (From {player.Name})`)
		return {Status = FtpStatus.UnknownError}
	elseif method == FtpMethod.Get then
		return getFile(player, data)
	elseif method == FtpMethod.Put and data == nil then
		warn(`Request ignored: the FTP method was "put", but a file wasn't provided. (From {player.Name})`)
		return {Status = FtpStatus.UnknownError}
	elseif method == FtpMethod.Put then
		return putFile(player, data)
	elseif method == FtpMethod.List then
		return listFiles(player)
	elseif method == FtpMethod.ListRemote then
		return listRemote(player)
	elseif method == FtpMethod.SwitchHost then
		return changeHost(player, data)
	end
end

return M
-- To learn recursion, look at the comment at line 4 of this file