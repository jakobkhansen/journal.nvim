local windows = require("journal.windows")
local M = {}

M.weekdays = {
    monday = 1,
    tuesday = 2,
    wednesday = 3,
    thursday = 4,
    friday = 5,
    saturday = 6,
    sunday = 7
}

M.wordcount = function(string)
    local count = 0
    for _ in string:gmatch(" ") do count = count + 1 end
    return count
end


M.append_lists = function(first_table, second_table)
    for _, v in ipairs(second_table) do table.insert(first_table, v) end
end

M.split = function(string, delim)
    local output = {}
    for w in string:gmatch(delim) do output[#output + 1] = w end
    return output
end

M.shallow_copy = function(table)
    local output = {}
    for k, v in pairs(table) do output[k] = v end
    return output
end

M.multiply_values = function(table, multiplier)
    local output = M.shallow_copy(table)
    for k, v in pairs(output) do output[k] = v * multiplier end
    return output
end

M.string_is_decimal = function(string)
    return string:match("^[%-|%+]?%d+$") ~= nil
end

M.is_windows = function()
    return jit.os == "Windows"
end

M.translate_to_windows_path = function(path)
    return path:gsub("/", "\\")
end

M.strptime = function(format, timestring)
    if (M.is_windows()) then
        return windows.windows_strptime(format, timestring)
    end

    return vim.fn.strptime(format, timestring)
end


return M
