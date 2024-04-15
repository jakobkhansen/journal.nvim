-- Adapted from AckslD/nvim-neoclip.lua

local M = {}

local defaults = {
    filetype = 'md',
    dir = '~/journal',
    date_format = '%d/%m/%Y',
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
    },
}

M.get = function()
    return defaults
end

M.journal_dir = function()
    if type(defaults.dir) == 'function' then
        return defaults.dir()
    end
    return defaults.dir
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
