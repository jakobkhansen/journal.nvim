local M = {}
-- Meta class
Date = { day = 0, month = 0, year = 0, wday = 0 }

-- Derived class method new

function Date:new(day, month, year)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.day = day or 0
    self.month = month or 0
    self.year = year
    return o
end

function Date:today()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    local data = os.date("*t")
    self.day = data.day
    self.month = data.month
    self.year = data.year
    self.wday = data.wday
    return o
end

function Date:yesterday()
    local o = {}
    setmetatable(o, self)
    self.__index = self

    local today = os.date("*t")
    today.day = today.day - 1
    local yesterday = os.date("*t", os.time(today))

    self.day = yesterday.day
    self.month = yesterday.month
    self.year = yesterday.year
    self.wday = yesterday.wday
    return o
end

function Date:relative(date)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    local today = os.date("*t")
    today.day = today.day + date
    local relative = os.date("*t", os.time(today))

    self.day = relative.day
    self.month = relative.month
    self.year = relative.year
    self.wday = relative.wday
    return o
end

function Date:to_string()
    return string.format("%02d/%02d/%d", self.day, self.month, self.year)
end

M.Date = Date

return M
