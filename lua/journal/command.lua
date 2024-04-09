local M = {}

local dateparser = require('journal.dateparser')
local fs = require('journal.filesystem')

local execute_journal_command = function(args)
    -- Try parse date
    local date = dateparser.parse_date(args.fargs)
    if (date ~= nil) then
        fs.open_day_entry(date)
        return
    end

    if (args.fargs[1] == 'week') then
        fs.open_week_entry(Date:today())
        return
    end

    if (args.fargs[1] == 'month') then
        fs.open_month_entry(Date:today())
        return
    end

    if (args.fargs[1] == 'year') then
        fs.open_year_entry(Date:today())
        return
    end

    print('Invalid journal entry')
end

M.setup = function()
    vim.api.nvim_create_user_command('Journal', execute_journal_command, { nargs = '*' })
end

return M
