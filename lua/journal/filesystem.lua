local M = {}

local config = require('journal.config').get()

local function create_directories(path)
    local success, error = os.execute(string.format("mkdir -p $(dirname %s)", path))
    if not success then
        return nil, error
    end
    return true
end

local function get_entry_path(date, format)
    local journal_dir = vim.fn.expand(config.dir)
    return journal_dir .. '/' .. os.date(format, os.time(date)) .. '.' .. config.filetype
end

M.open_entry = function(entry, template)
    create_directories(entry)
    vim.cmd('edit ' .. entry)
end

M.open_day_entry = function(date)
    local journal_file = get_entry_path(date, config.day_entry_format)
    M.open_entry(journal_file)
end

M.open_week_entry = function(date)
    local journal_file = get_entry_path(date, config.week_entry_format)
    M.open_entry(journal_file)
end

M.open_month_entry = function(date)
    local journal_file = get_entry_path(date, config.month_entry_format)
    M.open_entry(journal_file)
end

M.open_year_entry = function(date)
    local journal_file = get_entry_path(date, config.year_format)
    M.open_entry(journal_file)
end

return M
