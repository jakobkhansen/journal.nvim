local M = {}

local config = require('journal.config').get()

M.setup = function(opts)
    print(vim.inspect(config))
end

return M
