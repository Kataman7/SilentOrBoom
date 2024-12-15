Particul = {}

function Particul:new(x, y, radius, speed_x, speed_y, color, frame)
    local obj = {
        x = x or 0,
        y = y or 0,
        radius = radius or 3,
        speed_x = speed_x or 1,
        speed_y = speed_y or 1,
        color = color or 7,
        frame = (frame and frame * 60) or 5 * 60
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Particul:update()
    self.x = self.x + self.speed_x
    self.y = self.y + self.speed_y
    self.frame -= 1
end

function Particul:draw()
    circfill(self.x, self.y, self.radius, self.color)
end
