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
local ServerScriptService = game:GetService("ServerScriptService")
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
	},
	-- Used to gain root access
	["root.exe"] = {
		filesize = 812_132_591_320,
		permlevel = Data.Admin
	},
	-- Encrypted files needed to escape (15 total)
	["57fe2c78-aae7-4dda-aec4-45474493f910.enc"] = {
		filesize = 1_932_012_439_215,
		permlevel = Data.User
	},
	["619bf01e-29bb-4f4c-b477-feb6886c3b6a.enc"] = {
		filesize = 1_932_012_439_491,
		permlevel = Data.User
	},
	["aa4fd3a8-64b9-4477-8859-50837e1630b6.enc"] = {
		filesize = 1_932_012_440_196,
		permlevel = Data.User
	},
	["79d56f27-596a-431f-9949-da275c37342e.enc"] = {
		filesize = 2_012_942_012_813,
		permlevel = Data.User
	},
	["65248216-02de-4874-9ea3-6999877463ae.enc"] = {
		filesize = 2_012_942_012_813,
		permlevel = Data.User
	},
	["ca7f6220-d240-4933-9e76-0720bb0d3240.enc"] = {
		filesize = 2_012_942_012_813,
		permlevel = Data.User
	},
	["c0d70845-92ba-4989-830d-c6fe29fc813a.enc"] = {
		filesize = 2_012_942_012_813,
		permlevel = Data.User
	},
	["6262d44c-8f8a-458d-83f4-b52538e92636.enc"] = {
		filesize = 2_012_942_012_813,
		permlevel = Data.User
	},
	["cf38dcd5-f180-4c49-8668-62fc3acec658.enc"] = {
		filesize = 2_012_942_012_813,
		permlevel = Data.User
	},
	["5ce17b99-c06d-428b-8526-095396cf221d.enc"] = {
		filesize = 2_012_942_012_813,
		permlevel = Data.User
	},
	["783c957a-c130-447d-8be8-c6e7e28683e8.enc"] = {
		filesize = 2_012_942_012_813,
		permlevel = Data.User
	},
	["d4655140-7920-4799-8cfb-da060b527901.enc"] = {
		filesize = 2_012_942_012_813,
		permlevel = Data.User
	},
	["1138b84a-4129-425b-9ccf-42c2f6379b0b.enc"] = {
		filesize = 2_012_942_012_813,
		permlevel = Data.User
	},
	["7c8dccd8-5057-4840-b36e-0482ced81abb.enc"] = {
		filesize = 2_012_942_012_813,
		permlevel = Data.User
	},
	["6efc8e9d-a037-4d1e-acaa-2445503cf589.enc"] = {
		filesize = 2_012_942_012_813,
		permlevel = Data.User
	},
	-- Used in conjuction with root.exe to get root
	["pdebugger.exe"] = {
		filesize = 723_352_953_381,
		permlevel = Data.Admin
	}
}

return M