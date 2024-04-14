local M = {}

local dateparser = require('journal.dateparser')
local fs = require('journal.filesystem')
local config = require('journal.config').get()
local Date = require('journal.date').Date


local function parse_first_argument(arg)
    if (config.entries[arg] == nil) then
        -- TODO invalid type
        print('Invalid type')
        return nil
    end

    return config.entries[arg]
end

local execute_journal_command = function(args)
    local entry_config = nil
    local date = nil

    if (#args.fargs > 0) then
        entry_config = parse_first_argument(args.fargs[1])
    else
        entry_config = config.entries[vim.fn.keys(config.entries)[1]]
    end

    if (#args.fargs > 1) then
        -- TODO invalid date
        date = dateparser.parse_date(args.fargs[2], entry_config)
    else
        date = Date:today()
    end

    if (entry_config == nil or date == nil) then
        return
    end

    fs.open_entry(date, entry_config)
end

M.setup = function()
    vim.api.nvim_create_user_command(
        'Journal',
        execute_journal_command,
        {
            nargs = '*',
            complete = require("journal.autocomplete").get_autocompletion_items
        }
    )
end

return M
