local M = {}

local Date = require('journal.date').Date

local wdays = {
    monday = 1,
    tuesday = 2,
    wednesday = 3,
    thursday = 4,
    friday = 5,
    saturday = 6,
    sunday = 7
}

-- Takes a table of args from ":Journal" command
-- Returns a Data object
M.parse_date = function(date)
    if (next(date) == nil) then
        return Date:today()
    end
    if (string.lower(date[1]) == 'today') then
        return Date:today()
    end
    if (string.lower(date[1]) == 'yesterday') then
        return Date:yesterday()
    end
    if (date[1]:sub(1, 1) == '-' or date[1]:sub(1, 1) == '+') then
        return Date:relative(tonumber(date[1]))
    end
    -- Jumpts to the current weeks instance of wday
    if (wdays[date[1]:lower()] ~= nil) then
        return Date:weekday(wdays[date[1]:lower()])
    end

    return nil
end

return M
