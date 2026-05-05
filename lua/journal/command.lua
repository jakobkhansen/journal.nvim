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

local parse_date_argument = function(date, arg, entry)
    if arg == nil then
        return date
    end
    arg = string.lower(arg)
    if arg == 'last' then
        return date:last(entry)
    end
    if arg == 'next' then
        return date:next(entry)
    end
    if ((arg:sub(1, 1) == '-' or arg:sub(1, 1) == '+')
            and utils.string_is_decimal(arg)) then
        local num = tonumber(arg)
        local delta = utils.multiply_values(entry.frequency, num)
        return date:relative(delta)
    end
    if utils.string_is_decimal(arg) then
        local num = tonumber(arg)
        return date:monthday(num)
    end
    -- Jumps to the current weeks instance of wday
    if utils.weekdays[arg] ~= nil then
        return date:weekday(utils.weekdays[arg])
    end

    return date:from_datestring(config.date_format(), arg)
end

local parse_date = function(command_args, entry)
    local date = Date:today()

    -- Parse date_modifier in config
    if entry.date_modifier ~= nil then
        for _, arg in ipairs(utils.split(entry.date_modifier(), "%S+")) do
            date = parse_date_argument(date, arg, entry)

            if date == nil then
                return nil
            end
        end
    end

    -- Parse date modifiers in command
    if command_args ~= nil then
        for _, arg in ipairs(command_args) do
            date = parse_date_argument(date, arg, entry)

            if date == nil then
                return nil
            end
        end
    end

    return date
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

    local date = parse_date(args, entry)

    if valid_type(entry) == false or date == nil then
        return nil, nil
    end

    return entry, date
end


return M
