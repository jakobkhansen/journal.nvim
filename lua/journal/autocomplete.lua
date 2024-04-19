local M = {}

local Date = require('journal.date').Date

local config = require('journal.config').get()

local utils = require('journal.utils')

local function get_entry_type_completion(entry_config)
    return vim.fn.keys(entry_config)
end


local function get_modifiers(entry_config)

    if (entry_config == nil)
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

    utils.append_lists(output, vim.fn.keys(utils.weekdays))

    return output
end

M.get_autocompletion_items = function(_, cmdline)
    local words = utils.split(cmdline, '(%S+) ')

    if #words == 1 then
        return get_entry_type_completion(config.entries)
    end

    print(vim.inspect(words))
    local current_type = config.entries[words[2]]
    print(vim.inspect(current_type))

    local index = 3
    while current_type ~= nil and index <= #words and current_type.sub_entries ~= nil do
        current_type = current_type.sub_entries[words[index]]
        index = index + 1
    end

    local output = {}

    if current_type ~= nil and current_type.sub_entries ~= nil then
        utils.append_lists(output, get_entry_type_completion(current_type.sub_entries))
    end

    if current_type.format ~= nil then
        utils.append_lists(output, get_modifiers(words[index - 1]))
    end

    return output
end

return M
