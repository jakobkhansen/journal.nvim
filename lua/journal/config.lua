-- Adapted from AckslD/nvim-neoclip.lua

local M = {}

local defaults = {
    filetype = 'md',                    -- Filetype to use for new journal entries
    root = '~/journal',                 -- String or () => String. Root directory for journal entries
    date_format = '%d/%m/%Y',           -- Date format for `:Journal <date-modifier>`
    autocomplete_date_modifier = "end", -- "always"|"never"|"end". Enable date modifier autocompletion

    -- Configuration for journal entries
    journal = {
        -- Default configuration for `:Journal <date-modifier>`
        format = '%Y/%m-%B/daily/%d-%A',
        template = '# %A %B %d %Y\n',
        frequency = { day = 1 },

        -- Nested configurations for `:Journal <type> <type> ... <date-modifier>`
        entries = {
            day = {
                format = '%Y/%m-%B/daily/%d-%A', -- Format of the journal entry in the filesystem. See `:help strftime` for options
                template = '# %A %B %d %Y\n',    -- Template used when creating a new journal entry
                frequency = { day = 1 },         -- The frequency of the journal entry. Used for `:Journal next`, `:Journal -2` etc
            },
            week = {
                format = '%Y/%m-%B/weekly/week-%U',
                template = "# Week %W %B %Y\n",
                frequency = { day = 7 },
                default_date_modifier = "monday" -- Default date modifier, makes `:Journal week` = `:Journal week monday`
            },
            month = {
                format = '%Y/%m-%B/%B',
                template = "# %B %Y\n",
                frequency = { month = 1 }
            },
            year = {
                format = '%Y/%Y',
                template = "# %Y\n",
                frequency = { year = 1 }
            },
        },
    }
}

M.get = function()
    return defaults
end

M.journal_dir = function()
    if type(defaults.root) == 'function' then
        return defaults.root()
    end
    return defaults.root
end

local function merge_configs(user_config, config)
    if user_config == nil then
        user_config = {}
    end
    for key, value in pairs(user_config) do
        config[key] = value
    end
end

M.setup = function(user_config)
    merge_configs(user_config, defaults)
end

return M
