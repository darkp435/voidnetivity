local ServerScriptService = game:GetService("ServerScriptService")
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

local M = {}

local Data = require(ServerScriptService["shared-data-module"])

M.fileTable = {
	["brute.exe"] = {
		filesize = 1_424_192_628,
		permlevel = Data.PermTypes.User
	},
	["aurora.exe"] = {
		filesize = 1_915_832_392,
		permlevel = Data.PermTypes.User
	},
	["unban.exe"] = {
		filesize = 2_641_932_185,
		permlevel = Data.PermTypes.User
	},
	["inject.exe"] = {
		filesize = 2_027_185_193,
		permlevel = Data.PermTypes.Maintainer
	},
	["compromise.exe"] = {
		filesize = 3_141_592_653,
		permlevel = Data.PermTypes.Maintainer
	},
	["cloak.exe"] = {
		filesize = 2_618_382_192,
		permlevel = Data.PermTypes.User
	},
	["hijack.exe"] = {
		filesize = 4_017_351_829,
		permlevel = Data.PermTypes.Root
	}
}

return M