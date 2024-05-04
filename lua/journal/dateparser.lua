local M = {}

local Date = require('journal.date').Date

local config = require('journal.config').get()

local utils = require('journal.utils')

-- Takes a table of args from ":Journal" command
-- Returns a Date object
M.parse_date = function(arg, entry_config)
    -- If no date-modifier is provided, use the default
    arg = arg or entry_config.default_date_modifier

    if arg == nil then
        return Date:today()
    end
    arg = string.lower(arg)
    if arg == 'last' then
        return Date:last(entry_config)
    end
    if arg == 'next' then
        return Date:next(entry_config)
    end
    if utils.string_is_decimal(arg) then
        local num = tonumber(arg)
        return Date:from_config(entry_config, num)
    end
    -- Jumps to the current weeks instance of wday
    if utils.weekdays[arg] ~= nil then
        return Date:weekday(utils.weekdays[arg])
    end

    return Date:from_datestring(config.date_format, arg)
end


return M
