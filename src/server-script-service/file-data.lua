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

local function newFile(size: number, permlevel: Data.Permission)
    return {
        size = size,
        permlevel = permlevel
    }
end

local BRUTE_FILE_SIZE = 1_424_192_628
local AURORA_FILE_SIZE = 1_915_832_392

M.fileTable = {
    ["brute.exe"] = newFile(BRUTE_FILE_SIZE, Data.PermTypes.User),
    ["aurora.exe"] = newFile(AURORA_FILE_SIZE, Data.PermTypes.User)
}

return M