local M = {}

local command = require("journal.command")

local journal_command = function(args)
    command.execute(args.fargs)
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
