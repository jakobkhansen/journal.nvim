local M = {}

local Date = require('journal.date').Date

-- Takes a table of args from ":Journal" command
-- Returns a Data object
M.parse_date = function(date)
    if (string.lower(date[1]) == 'today') then
        return Date:today()
    end
    if (string.lower(date[1]) == 'yesterday') then
        return Date:yesterday()
    end
    if (date[1]:sub(1, 1) == '-' or date[1]:sub(1, 1) == '+') then
        return Date:relative(tonumber(date[1]))
    end

    return nil
end

return M
