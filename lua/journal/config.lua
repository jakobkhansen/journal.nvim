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
                format = '%Y/%m-%B/daily/%d-%A', -- Format of the journal entry in the filesystem. See `:h strftime` and `man strftime` for details
                template = '# %A %B %d %Y\n',    -- Template used when creating a new journal entry
                frequency = { day = 1 },         -- The frequency of the journal entry. Used for `:Journal next`, `:Journal -2` etc
            },
            week = {
                format = '%Y/%m-%B/weekly/week-%W',
                template = "# Week %W %B %Y\n",
                frequency = { day = 7 },
                date_modifier = "monday" -- Applied before other date modifier given to `:Journal`
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

local function is_dict_like(tbl)
    return type(tbl) == 'table' and not vim.tbl_islist(tbl)
end

local merge_configs = function(user_config, config)
    if user_config == nil then
        user_config = {}
    end
    for key, value in pairs(user_config) do
        if type(value) == string then
            config[key] = function() return value end
        end
        config[key] = value
    end
end

local function convert_strings_to_functions(config)
    for key, value in pairs(config) do
        if is_dict_like(config[key]) then
            convert_strings_to_functions(config[key])
        else
            if type(value) == "string" then
                config[key] = function() return value end
            end
        end
    end
end

M.setup = function(user_config)
    merge_configs(user_config, defaults)
    convert_strings_to_functions(defaults)
end

return M
