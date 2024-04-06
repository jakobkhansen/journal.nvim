local M = {}

M.setup = function(opts)
    require('journal.config').setup(opts)
    print(vim.inspect(require('journal.config').get()))
end

return M
