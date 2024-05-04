local M = {}

local format_specifiers = {
    ["\\%%\\Y"] = "yyyy",
    ["\\%%\\m"] = "%M",
    ["\\%%\\d"] = "dd",
    ["\\%%\\A"] = "dddd",
    ["\\%%\\B"] = "MMMM",
    ["\\%%\\U"] = "ff",
    ["\\%%\\W"] = "ff",
}

local escape_all_characters = function(input)
    return string.gsub(input, "(.)", "\\%1")
end

local convert_formats = function(input)
    for k, v in pairs(format_specifiers) do
        input = string.gsub(input, k, v)
    end

    return input
end

M.windows_strptime = function(format, timestring)
    local escaped_format = escape_all_characters(format)
    local converted_format = convert_formats(escaped_format)
    local command = "powershell -command Get-Date $([DateTime]::ParseExact('" ..
        timestring .. "', '" .. converted_format .. "', [CultureInfo].InvariantCulture)) -UFormat '%s'"

    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()

    local timestamp = math.floor(tonumber(result))

    return timestamp
end

return M
