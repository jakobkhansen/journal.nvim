local M = {}

local Date = require('journal.date').Date

local config = require('journal.config').get()

local utils = require('journal.utils')

local function get_entry_type_completion(entry_config)
    return vim.fn.keys(entry_config)
end

local function should_auto_complete_date(is_at_end)
    if (config.autocomplete_date_modifier() == "always")
    then
        return true
    elseif config.autocomplete_date_modifier() == "never" then
        return false
    elseif config.autocomplete_date_modifier() == "end" then
        return is_at_end
    end
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
        Date:today():to_format(config.date_format()),
    }

    utils.append_lists(output, vim.fn.keys(utils.weekdays))

    return output
end

M.get_autocompletion_items = function(_, cmdline)
    local words = utils.split(cmdline, '(%S+) ')

    local current_type = config.journal

    local index = 2
    while current_type ~= nil and index <= #words and current_type.entries ~= nil do
        current_type = current_type.entries[words[index]]
        index = index + 1
    end

    if current_type == nil then
        return {}
    end

    local output = {}

    local has_more_entries = current_type ~= nil and current_type.entries ~= nil

    if has_more_entries then
        utils.append_lists(output, get_entry_type_completion(current_type.entries))
    end

    if current_type.format ~= nil and should_auto_complete_date(not has_more_entries) then
        utils.append_lists(output, get_modifiers(words[index - 1]))
    end

    return output
end

return M
