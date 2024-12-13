Camera = Entity:new()

function Camera:new()
    local obj = Entity.new(self, 64, 64, 8, 8, 5, 0, 0.85, 0)
    setmetatable(obj, self)
    obj.lerp_factor = 0.1
    self.__index = self
    return obj
end

function Camera:update()
   --self.x = self.x + (player.x - self.x) * self.lerp_factor
   --self.y = self.y + (player.y - self.y) * self.lerp_factor

    self.x = player.x
    self.y = player.y
end

function Camera:draw()
    camera(self.x - 64 + player.w / 2, self.y - 64 + player.h / 2)
end
