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
local module = {}
local ServerScriptService = game:GetService("ServerScriptService")
local datamodule = require(ServerScriptService["shared-data-module"])

function module.verifyPerms(userid, hostname): boolean
    if datamodule.getPerms(userid, hostname) ~= "none" then
        return true
    else
        return false
    end
end

return module
