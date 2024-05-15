local M = {}

local utils = require('journal.utils')

-- Date is a class that represents a date. It can be used to create dates, get relative dates from an existing date, and format dates.
-- The `.date` field is a table which can be used with `os.time` and `os.date` functions.
Date = { date = { day = 0, month = 0, year = 0, wday = 0, hour = 0, min = 0, sec = 0 } }

-- Takes a table containing day, month, year, wday, hour, min, sec
function Date:new(date)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    self.date = utils.shallow_copy(date)

    return o
end

function Date:today()
    return Date:new(os.date("*t"))
end

-- Returns relative date from the current date
function Date:relative(delta)
    local date = Date:new(self.date)

    date.date = Date:new(self.date).date
    date.date = utils.add_tables(date.date, delta)

    local relative = os.date("*t", os.time(date.date))

    date.date = relative

    return date
end

function Date:last(config)
    local frequency = config.frequency or { day = 1, month = 0, year = 0 }
    local delta = utils.multiply_values(frequency, -1)
    return self:relative(delta)
end

function Date:next(config)
    local frequency = config.frequency or { day = 1, month = 0, year = 0 }
    local delta = utils.multiply_values(frequency, 1)
    return self:relative(delta)
end

-- Returns date of this months instance of monthday (number)
function Date:monthday(monthday)
    local date = Date:new(self.date)
    date.day = monthday
    return date
end

-- Returns date of this weeks instance of wday
function Date:weekday(wday)
    local today_w = tonumber(os.date("%u", os.time(self.date)))
    local days_delta = wday - today_w

    return self:relative({ day = days_delta, month = 0, year = 0 })
end

function Date:from_datestring(format, datestring)
    local o = {}

    setmetatable(o, self)
    self.__index = self

    local timestamp = utils.strptime(format, datestring)
    if timestamp == 0 then
        return nil
    end

    local date = os.date("*t", timestamp)

    if date == nil then
        return nil
    end

    self.date = date

    return o
end

function Date:to_format(format)
    return os.date(format, os.time(self.date))
end

function Date:to_string()
    return string.format("%02d/%02d/%d", self.day, self.month, self.year)
end

M.Date = Date

return M
