local M = {}
-- Meta class
Date = {day = 0, month = 0, year = 0}

-- Derived class method new

function Date:new (o, day, month, year)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   self.day = day or 0
   self.month = month or 0
   self.year = year
   return o
end

function Date:today (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.day = os.date("%d")
    self.month = os.date("%m")
    self.year = os.date("%Y")
    return o
end

function Date:to_string()
    return string.format("%02d/%02d/%d", self.day, self.month, self.year)
end

M.Date = Date

return M
