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
		filesize = 153_424_192_628,
		permlevel = Data.User
	},
    -- Used to gain access to a remote host
	["aurora.exe"] = {
		filesize = 192_915_832_392,
		permlevel = Data.User
	},
    -- Used to get unbanned
	["unban.exe"] = {
		filesize = 358_641_932_185,
		permlevel = Data.User
	},
    -- Used to gain access to a remote host
    -- for security levels 3-4
	["inject.exe"] = {
		filesize = 302_027_185_193,
		permlevel = Data.Maintainer
	},
    -- Used to gain access to a remote host
    -- for security levels 3-4
	["compromise.exe"] = {
		filesize = 314_159_265_359,
		permlevel = Data.Maintainer
	},
    -- Used to add more time to hosts that have
    -- higher security levels before kicking you
	["cloak.exe"] = {
		filesize = 262_618_382_192,
		permlevel = Data.User
	},
    -- Used to get processing power from regular hosts
	["hijack.exe"] = {
		filesize = 421_017_351_829,
		permlevel = Data.Root
	},
    -- Used to gain access to a remote host
    -- for security levels 5+
    ["mouse.exe"] = {
        filesize = 390_582_951_422,
        permlevel = Data.Developer
    }
}

return M