local M = {}

M.warn = function(msg)
    vim.cmd(string.format('echohl WarningMsg | echo "Journal.nvim Warning: %s" | echohl None', msg))
end

return M
