-- Enumeration for player attributes
local PlayerAttributes = {
    btc = "btc"
}

table.freeze(PlayerAttributes)

export type PlayerAttributes = typeof(PlayerAttributes)

return PlayerAttributes