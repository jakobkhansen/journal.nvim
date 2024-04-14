local M = {}

local utils = require('journal.utils')

Date = { day = 0, month = 0, year = 0, wday = 0 }

function Date:relative(delta)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    local today = os.date("*t")
    today.day = today.day + delta.day
    today.month = today.month + delta.month
    today.year = today.year + delta.year

    local relative = os.date("*t", os.time(today))

    self.day = relative.day
    self.month = relative.month
    self.year = relative.year
    self.wday = relative.wday
    return o
end

function Date:from_config(config, multiplier)
    multiplier = multiplier or 1
    local delta = utils.multiply_values(config.frequency, multiplier)
    return Date:relative(delta)
end

function Date:today()
    return Date:relative({ day = 0, month = 0, year = 0 })
end

function Date:last(config)
    local delta = utils.multiply_values(config.frequency, -1)
    return Date:relative(delta)
end

function Date:next(config)
    local delta = utils.multiply_values(config.frequency, 1)
    return Date:relative(delta)
end

-- Returns date of this weeks instance of wday
function Date:weekday(wday)
    local today_w = tonumber(os.date("%u"))
    local days_delta = wday - today_w

    return Date:relative(days_delta)
end

function Date:from_timestamp(timestamp)
    local o = {}

    setmetatable(o, self)
    self.__index = self

    local date = os.date("*t", timestamp)

    self.day = date.day
    self.month = date.month
    self.year = date.year
    self.wday = date.wday

    return o
end

function Date:to_format(format)
    return os.date(format, os.time(self))
end

function Date:to_string()
    return string.format("%02d/%02d/%d", self.day, self.month, self.year)
end

M.Date = Date

return M
