local M = {}

local dateparser = require('journal.dateparser')
local fs = require('journal.filesystem')
local config = require('journal.config').get()
local Date = require('journal.date').Date


local function parse(config, arg)
    if (config[arg] == nil) then
        -- TODO invalid type
        print('Invalid type')
        return nil
    end

    return config[arg]
end

local valid_type = function(entry_config)
    if entry_config == nil or entry_config.format == nil
    then
        print('Invalid type')
        return false
    end
end

local journal_command = function(args)
    M.execute(args.fargs)
end

M.execute = function(args)
    local current_type = nil
    if #args > 0 then
        current_type = parse(config.entries, args[1])
    else
        current_type = config.entries[vim.fn.keys(config.entries)[1]]
    end
    table.remove(args, 1)

    while current_type ~= nil and #args > 0 and current_type.sub_entries ~= nil do
        current_type = parse(current_type.sub_entries, args[1]) or current_type
        table.remove(args, 1)
    end

    local date = dateparser.parse_date(args[1], current_type)

    if valid_type(current_type) == false or date == nil then
        return
    end

    fs.open_entry(date, current_type)
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
