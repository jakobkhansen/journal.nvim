local M = {}

local Date = require('journal.date').Date

local config = require('journal.config').get()

local wdays = {
    monday = 1,
    tuesday = 2,
    wednesday = 3,
    thursday = 4,
    friday = 5,
    saturday = 6,
    sunday = 7
}

local function try_parse_date_string(date_string)
    local date = vim.fn.strptime(config.date_format, date_string)

    if (date == 0) then
        return nil
    end

    return Date:from_timestamp(date)
end

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
    if (string.lower(date[1]) == 'tomorrow') then
        return Date:tomorrow()
    end
    if (
        date[1]:sub(1, 1) == '-'
        or date[1]:sub(1, 1) == '+'
        or date[1]:sub(1, 1) == '0'
    ) then
        return Date:relative(tonumber(date[1]))
    end
    -- Jumps to the current weeks instance of wday
    if (wdays[date[1]:lower()] ~= nil) then
        return Date:weekday(wdays[date[1]:lower()])
    end

    return try_parse_date_string(date[1]:lower())
end


return M
