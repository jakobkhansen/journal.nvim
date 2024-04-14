local M = {}

local Date = require('journal.date').Date

local config = require('journal.config').get()

M.get_autocompletion_items = function()
    return {
        Date:today():to_format(config.date_format),
        'week',
        'month',
        'year',
        'today',
        'yesterday',
        'tomorrow',
        'monday',
        'tuesday',
        'wednesday',
        'thursday',
        'friday',
        'saturday',
        'sunday',
        '+1',
        '-1',
    }
end

return M
