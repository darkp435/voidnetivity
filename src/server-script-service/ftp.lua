-- SPDX-License-Identifier: Apache-2.0
-- Copyright (c) 2025 darkp435

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FtpEnum = require(ReplicatedStorage:WaitForChild("ftp-status-codes"))
local FtpMethod = FtpEnum.Methods
local FtpStatus = FtpEnum.FtpStatus
local M = {}

local function exitFTP()

end

local function getFile(file)

end

local function putFile(file)

end

local function listFiles()

end

--- Remote function. Returns a table with these properties:
--- `Status`: the status of the request
--- `FileList?`: when sending a put request, returns the list of files
---@param player Player The player who sent the request.
---@param method string The FTP request method.
---@param file string The file, optional if the request is not get or put.
function M.ftpEvent(player: Player, method: string, file: string?): {Status: string, FileList: {string}?}
	if method == FtpMethod.Exit then
		return exitFTP()
	elseif method == FtpMethod.Get and file == nil then
		warn(`Request ignored: the FTP method was get, but a file wasn't provided. (From {player.Name})`)
		return FtpStatus.UnknownError
	elseif method == FtpMethod.Get then
		return getFile(file)
	elseif method == FtpMethod.Put and file == nil then
		warn(`Request ignored: the FTP method was put, but a file wasn't provided. (From {player.Name})`)
		return FtpStatus.UnknownError
	elseif method == FtpMethod.Put then
		return putFile(file)
	elseif method == FtpMethod.List then
		return listFiles()
	end
end

return M