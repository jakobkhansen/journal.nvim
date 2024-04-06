local M = {}

local Date = require('journal.date').Date

-- Takes a table of args from ":Journal" command
-- Returns a Data object
M.parse_date = function(date)
    if (string.lower(date[1]) == 'today') then
        return Date:today()
    end

    return nil
end

return M
