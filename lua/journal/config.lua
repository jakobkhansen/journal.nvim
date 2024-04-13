-- Adapted from AckslD/nvim-neoclip.lua

local M = {}

local defaults = {
    filetype = 'md',
    dir = '~/journal',
    date_format = '%d/%m/%Y',
    journal_format = {
        day = '%Y/%m-%B/daily/%d-%A',
        week = '%Y/%m-%B/weekly/week-%W',
        month = '%Y/%m-%B/%B',
        year = '%Y/%Y',
    },
    templates = {
        day = "# %A %B %d %Y\n",
        week = "# Week %W %B %Y\n",
        month = "# %B %Y\n",
        year = "# %Y\n",
    }
}

M.get = function()
    return defaults
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
