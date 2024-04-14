local M = {}

local Date = require('journal.date').Date

local config = require('journal.config').get()

local utils = require('journal.utils')

local function get_types()
    return vim.fn.keys(config.entries)
end


local function get_modifiers(type)
    local type_config = config.entries[type]

    if (type_config == nil)
    then
        return {}
    end

    local output = {
        'last',
        'next',
        '-1',
        '+1',
        Date:today():to_format(config.date_format),
    }

    if (type_config.frequency.day == 1)
    then
        utils.append_lists(output, vim.fn.keys(utils.weekdays))
    end

    return output
end

M.get_autocompletion_items = function(_, cmdline)
    if (utils.wordcount(cmdline) < 2)
    then
        return get_types()
    end

    local selected_type = utils.split(cmdline, '%S+')[2]
    return get_modifiers(selected_type)
end

return M
