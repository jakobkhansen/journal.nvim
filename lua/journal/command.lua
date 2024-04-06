local M = {}

local dateparser = require('journal.dateparser')

local execute_journal_command = function(args)
    local date = dateparser.parse_date(args.fargs)
    print(date:to_string())
end

M.setup = function()
    vim.api.nvim_create_user_command('Journal', execute_journal_command, { nargs = '*' })
end

return M
