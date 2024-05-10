local M = {}

local fs = require('journal.filesystem')
local config = require('journal.config').get()
local log = require('journal.logging')
local utils = require('journal.utils')
local Date = require('journal.date').Date

local valid_type = function(entry_config)
    if entry_config == nil or entry_config.format == nil
    then
        return false
    end
end

local parse_entry = function(args)
    local current_type = config.journal

    while current_type ~= nil and #args > 0 and current_type.entries ~= nil do
        local next_type = current_type.entries[args[1]]

        if next_type == nil then
            break
        end

        current_type = next_type
        table.remove(args, 1)
    end

    return current_type
end

local parse_date = function(arg, entry)
    -- If no date-modifier is provided, use the default
    arg = arg or entry.date_modifier

    if arg == nil then
        return Date:today()
    end
    arg = string.lower(arg)
    if arg == 'last' then
        return Date:last(entry)
    end
    if arg == 'next' then
        return Date:next(entry)
    end
    if ((arg:sub(1, 1) == '-' or arg:sub(1, 1) == '+')
            and utils.string_is_decimal(arg)) then
        local num = tonumber(arg)
        return Date:multiplier(entry, num)
    end
    if utils.string_is_decimal(arg) then
        local num = tonumber(arg)
        return Date:monthday(num)
    end
    -- Jumps to the current weeks instance of wday
    if utils.weekdays[arg] ~= nil then
        return Date:weekday(utils.weekdays[arg])
    end

    return Date:from_datestring(config.date_format, arg)
end

M.execute = function(args)
    local entry, date = M.parse_command(args)

    if valid_type(entry) == false or date == nil then
        log.warn('Invalid entry type or date modifier')
        return
    end

    fs.open_entry(date, entry)

    return true
end

M.parse_command = function(args)
    local entry = parse_entry(args)

    local date = parse_date(args[1], entry)

    if valid_type(entry) == false or date == nil then
        return nil, nil
    end

    return entry, date
end


return M
