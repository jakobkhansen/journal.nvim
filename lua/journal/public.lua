local M = {}

local command = require("journal.command")

local utils = require("journal.utils")

M.command = function(string)
    command.execute(utils.split(string, "%S+"))
end

return M
