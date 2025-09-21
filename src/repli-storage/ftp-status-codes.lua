-- SPDX-License-Identifier: Apache-2.0
-- Copyright (c) 2025 darkp435

local M = {}

M.FtpStatus = {
	Success = "success",
	BrokenPipe = "brokepipe",
	Interrupted = "interrupt",
	UnknownError = "unknown",
	PermDenied = "pdenied"
}

table.freeze(M.FtpStatus)

M.Methods = {
	Get = "get",
	Put = "put",
	List = "list",
	ListRemote = "listr",
	Exit = "exit",
	SwitchHost = "chhost"
}

table.freeze(M.Methods)

return M