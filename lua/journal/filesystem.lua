local M = {}

local config = require('journal.config').get()

local function get_entry_path(date, format)
    local journal_dir = vim.fn.expand(config.dir)
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
        print('Error creating file') -- TODO logging
        return nil
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

M.open_entry = function(entry)
    vim.cmd('edit ' .. entry)
end

M.open_day_entry = function(date)
    local template = config.templates.day or ""
    local journal_file = get_entry_path(date, config.journal_format.day)

    create_if_not_exists(journal_file, date, template)
    M.open_entry(journal_file)
end

M.open_week_entry = function(date)
    local template = config.templates.week or ""
    local journal_file = get_entry_path(date, config.journal_format.week)

    create_if_not_exists(journal_file, date, template)
    M.open_entry(journal_file)
end

M.open_month_entry = function(date)
    local template = config.templates.month or ""
    local journal_file = get_entry_path(date, config.journal_format.month)

    create_if_not_exists(journal_file, date, template)
    M.open_entry(journal_file)
end

M.open_year_entry = function(date)
    local template = config.templates.year or ""
    local journal_file = get_entry_path(date, config.journal_format.year)

    create_if_not_exists(journal_file, date, template)
    M.open_entry(journal_file)
end

return M
