local M = {}

local config = require('journal.config').get()
local log = require('journal.logging')



local function get_entry_path(date, format)
    local journal_dir = vim.fn.expand(require('journal.config').journal_dir())
    return journal_dir .. '/' .. os.date(format, os.time(date)) .. '.' .. config.filetype
end

local function entry_exists(entry)
    return vim.fn.filereadable(entry) == 1
end

local function create_directories(entry)
    local success, error = os.execute(string.format("mkdir -p $(dirname %s)", entry))
    if not success then
        return nil, error
    end
    return true
end

local function create_entry(entry, date, template)
    local template_string = date:to_format(template)
    local file = io.open(entry, 'w')

    if file == nil then
        log.warn('Error creating file')
        return
    end

    file:write(template_string)
    file:close()
end


local function create_if_not_exists(entry, date, template)
    if not entry_exists(entry) then
        create_directories(entry)
        create_entry(entry, date, template)
    end
end

local function open_file(file)
    vim.cmd('e ' .. file)
end

M.open_entry = function(date, entry_config)
    local template = entry_config.template or ""
    local journal_file = get_entry_path(date, entry_config.format)

    create_if_not_exists(journal_file, date, template)
    open_file(journal_file)
end

return M
