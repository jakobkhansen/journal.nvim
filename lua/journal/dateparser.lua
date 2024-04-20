local M = {}

local Date = require('journal.date').Date

local config = require('journal.config').get()

local utils = require('journal.utils')

-- Takes a table of args from ":Journal" command
-- Returns a Data object
M.parse_date = function(arg, entry_config)
    if arg == nil then
        return Date:today(entry_config)
    end
    arg = string.lower(arg)
    if arg == 'last' then
        return Date:last(entry_config)
    end
    if arg == 'next' then
        return Date:next(entry_config)
    end
    if tonumber(arg) ~= nil then
        local num = tonumber(arg)
        return Date:from_config(entry_config, num)
    end
    -- Jumps to the current weeks instance of wday
    if utils.weekdays[arg] ~= nil then
        return Date:weekday(entry_config, utils.weekdays[arg])
    end

    return Date:from_datestring(entry_config, config.date_format, arg)
end


return M
