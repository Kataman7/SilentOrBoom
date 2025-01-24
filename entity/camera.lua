Camera = Entity:new()

function Camera:new()
    local obj = Entity.new(self, 64, 64, 8, 8, 5, 0, 0.85, 0)
    setmetatable(obj, self)
    obj.lerp_factor = 0.5
    obj.target = player
    self.__index = self
    return obj
end

function Camera:update()
   --self.x = self.x + (self.target.x - self.x) * self.lerp_factor
   --self.y = self.y + (self.target.y - self.y) * self.lerp_factor

    self.x = self.target.x
    self.y = self.target.y
end

function Camera:draw()
    camera(self.x - 64 + self.target.w / 2, self.y - 64 + self.target.h / 2)
end
