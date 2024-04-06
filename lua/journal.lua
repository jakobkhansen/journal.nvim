local M = {}

M.setup = function(opts)
    require('journal.config').setup(opts)
    require('journal.command').setup()
end

return M
