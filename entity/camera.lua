Camera = Entity:new()

function Camera:new()
    local obj = Entity.new(self, 64, 64, 8, 8, 5, 0, 0.85, 0)
    setmetatable(obj, self)
    obj.lerp_factor = 0.5
    obj.target = player
    obj.levierY = 0
    self.x = 0
    self.y = 0
    self.__index = self
    return obj
end

function Camera:update()
   --self.x = self.x + (self.target.x - self.x) * self.lerp_factor
   --self.y = self.y + (self.target.y - self.y) * self.lerp_factor

    self.x = self.target.x
    if player.x<600 and player.x>300 then
        self.y = self.target.y + self.levierY
    else
        self.y = self.target.y
    end
end

function Camera:draw()
    camera(self.x - 64 + self.target.w / 2, self.y - 64 + self.target.h / 2)
end

function Camera:resets()
    --remet la camera a la position par défaut
    camera()
end