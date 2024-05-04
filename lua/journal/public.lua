local M = {}

local command = require("journal.command")
local fs = require("journal.filesystem")

local utils = require("journal.utils")

-- Executes :Journal command with the given string as args
M.command = function(string)
    command.execute(utils.split(string, "%S+"))
end

-- Opens a journal entry for the given date and config
M.open_entry = function(date, config)
    fs.open_entry(date, config)
end

return M
