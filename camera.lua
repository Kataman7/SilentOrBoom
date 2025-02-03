Camera = {}

function Camera:new(target)
    local obj = {
        x = 0,
        y = 0,
        target = target,
        levierX = 0,
        levierY = 0
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Camera:update()
    self.x = self.target.x + self.levierX
    self.y = self.target.y + self.levierY
end

function Camera:draw()
    camera(self.x - 64 + self.target.w / 2, self.y - 64 + self.target.h / 2)
end