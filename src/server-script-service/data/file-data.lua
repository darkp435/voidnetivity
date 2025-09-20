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

local Data = require(ServerScriptService["perm-enums"])

-- Table of files and their data
M.fileTable = {
    -- Used to gain access to a remote host
	["brute.exe"] = {
		filesize = 1_424_192_628,
		permlevel = Data.User
	},
    -- Used to gain access to a remote host
	["aurora.exe"] = {
		filesize = 1_915_832_392,
		permlevel = Data.User
	},
    -- Used to get unbanned
	["unban.exe"] = {
		filesize = 2_641_932_185,
		permlevel = Data.User
	},
    -- Used to gain access to a remote host
    -- for security levels 3-4
	["inject.exe"] = {
		filesize = 2_027_185_193,
		permlevel = Data.Maintainer
	},
    -- Used to gain access to a remote host
    -- for security levels 3-4
	["compromise.exe"] = {
		filesize = 3_141_592_653,
		permlevel = Data.Maintainer
	},
    -- Used to add more time to hosts that have
    -- higher security levels before kicking you
	["cloak.exe"] = {
		filesize = 2_618_382_192,
		permlevel = Data.User
	},
    -- Used to get processing power from regular hosts
	["hijack.exe"] = {
		filesize = 4_017_351_829,
		permlevel = Data.Root
	},
    -- Used to gain access to a remote host
    -- for security levels 5+
    ["mouse.exe"] = {
        filesize = 3_582_951_422,
        permlevel = Data.Developer
    }
}

return M