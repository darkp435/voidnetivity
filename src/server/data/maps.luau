local M = {}

-- All of the locations are relative to the center since the absolute position
-- will change during implementation. Minimum and maximum values are -1000 and
-- 1000 respectively, i.e. the x, y and z values cannot be from
M.mapData = {
    home = {
        spawnLocation = {
            x = 0,
            y = 500,
            z = 0
        }
    },
    volcano = {
        x = 200,
        y = 520,
        z = 0
    }
}

table.freeze(M.mapData)

return M