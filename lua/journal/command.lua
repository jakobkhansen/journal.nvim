local M = {}

local dateparser = require('journal.dateparser')
local fs = require('journal.filesystem')
local config = require('journal.config').get()
local log = require('journal.logging')


local function parse(config, arg)
    if (config[arg] == nil) then
        return nil
    end

    return config[arg]
end

local valid_type = function(entry_config)
    if entry_config == nil or entry_config.format == nil
    then
        return false
    end
end

local journal_command = function(args)
    M.execute(args.fargs)
end

M.parse_command = function(args)
    local current_type = config.journal

    while current_type ~= nil and #args > 0 and current_type.entries ~= nil do
        local next_type = parse(current_type.entries, args[1])

        if next_type == nil then
            break
        end

        current_type = next_type
        table.remove(args, 1)
    end

    local date = dateparser.parse_date(args[1], current_type)

    if valid_type(current_type) == false or date == nil then
        return nil, nil
    end

    return current_type, date
end

M.execute = function(args)
    local current_type, date = M.parse_command(args)

    if valid_type(current_type) == false or date == nil then
        log.warn('Invalid entry type or date modifier')
        return
    end

    fs.open_entry(date, current_type)

    return true
end

M.setup = function()
    vim.api.nvim_create_user_command(
        'Journal',
        journal_command,
        {
            nargs = '*',
            complete = require("journal.autocomplete").get_autocompletion_items
        }
    )
end

return M
