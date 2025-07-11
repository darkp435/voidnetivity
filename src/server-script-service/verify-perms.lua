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