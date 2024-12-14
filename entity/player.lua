Player = Entity:new()

function Player:new()
    local obj = Entity.new(self, 64, 64, 8, 8, 0.2, 0.4, 0.85, 1)
    obj.jump_f = 5
    obj.jump_c = 0
    obj.jump_m = 3
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Player:control()
    
    if btn(1) then
        self.velx = self.velx + self.speed
        --self.x += self.speed * 5
    end
    if btn(0) then
        self.velx = self.velx - self.speed
        --self.x -= self.speed * 5
    end
    if btnp(2) then
        if self.jump_c < self.jump_m then
            self.vely = -self.jump_f
            self.jump_c = self.jump_c + 1
        end
    end
end

function Player:update()
    self:control()
    Entity.update(self)

    
    if self.vely == 0 then
        self.jump_c = 0
    end
end
