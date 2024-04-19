-- Adapted from AckslD/nvim-neoclip.lua

local M = {}

local defaults = {
    filetype = 'md', -- Filetype to use for new journal entries
    root = '~/journal', -- Root directory for journal entries
    date_format = '%d/%m/%Y', -- Date format for :Journal <date-modifier>
    autocomplete_date_modifier = "end", -- "always"|"never"|"end". Enable date modifier autocompletion

    -- Configuration for journal entries
    journal = {
        -- Default configuration for :Journal <date-modifier>
        format = '%Y/%m-%B/daily/%d-%A',
        template = '# %A %B %d %Y custom\n',
        frequency = { day = 1, month = 0, year = 0 },

        -- Nested configurations for :Journal <type> <type> ... <date-modifier>
        entries = {
            day = {
                format = '%Y/%m-%B/daily/%d-%A',
                template = '# %A %B %d %Y\n',
                frequency = { day = 1, month = 0, year = 0 },
            },
            week = {
                format = '%Y/%m-%B/weekly/week-%W',
                template = "# Week %W %B %Y\n",
                frequency = { day = 7, month = 0, year = 0 }
            },
            month = {
                format = '%Y/%m-%B/%B',
                template = "# %B %Y\n",
                frequency = { day = 0, month = 1, year = 0 }
            },
            year = {
                format = '%Y/%Y',
                template = "# %Y\n",
                frequency = { day = 0, month = 0, year = 1 }
            },
            projectA = {
                format = 'projectA/notes',
                template = "# Project A\n",
                entries = {
                    day = {
                        format = 'projectA/%Y/%m-%B/daily/%d-%A',
                        template = '# Project A: %A %B %d %Y\n',
                        frequency = { day = 1, month = 0, year = 0 },
                    },
                    week = {
                        format = 'ProjectA/%Y/%m-%B/weekly/week-%W',
                        template = "# Project A: Week %W %B %Y\n",
                        frequency = { day = 7, month = 0, year = 0 }
                    }
                }
            },
            projectB = {
                entries = {
                    day = {
                        format = 'projectB/%Y/%m-%B/daily/%d-%A',
                        template = '# Project B: %A %B %d %Y\n',
                        frequency = { day = 1, month = 0, year = 0 },
                    },
                    week = {
                        format = 'ProjectB/%Y/%m-%B/weekly/week-%W',
                        template = "# Project B: Week %W %B %Y\n",
                        frequency = { day = 7, month = 0, year = 0 }
                    }
                }
            }
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

local function is_dict_like(tbl)
    return type(tbl) == 'table' and not vim.tbl_islist(tbl)
end

local function merge_configs(user_config, config)
    if user_config == nil then
        user_config = {}
    end
    for key, value in pairs(user_config) do
        if is_dict_like(config[key]) then
            merge_configs(value, config[key])
        else
            config[key] = value
        end
    end
end

M.setup = function(user_config)
    merge_configs(user_config, defaults)
end

return M
