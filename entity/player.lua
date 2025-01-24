Player = Entity:new()

function Player:new()
    local obj = Entity.new(self, 64, 64, 8, 8, 0.2, 0.4, 0.85, 1)
    obj.jump_f = 5
    obj.jump_c = 0
    obj.jump_m = 3
    obj.anim_frame = 0
    obj.anim_speed = 10
    obj.life = 50
    obj.mineral = 0
    obj.tntPower = 10
    obj.tntRange = 100
    obj.tntSpeed = 100
    obj.stage = 0
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Player:tnt()
    local tnt = Tnt:new(self.x, self.y - 10, self.tntPower, self.tntRange, self.tntSpeed)
    add(tnts, tnt)
end

function Player:control()

    if btn(1) then
        self.velx = self.velx + self.speed
    end
    if btn(0) then
        self.velx = self.velx - self.speed
    end
    if btnp(2) then
        effects:jump(self.x + self.w / 2, self.y + self.h)
        if self.jump_c < self.jump_m then
            self.vely = -self.jump_f
            self.jump_c = self.jump_c + 1
        end
    end
    if (btnp(5)) then
        player:tnt()
    end
    if (btnp(4)) then
        effects:blood(self.x + self.w / 2, self.y + self.h)
    end
end

function Player:update()
    self:control()
    Entity.update(self)

    if self.velx ~= 0 and self.vely == 0 then
        self.anim_frame += 1
        if self.anim_frame >= self.anim_speed then
            self.anim_frame = 0
            if self.sprite == 2 then
                self.sprite = 3
            else
                self.sprite = 2
            end
        end    
        effects:walk(self.x + self.w / 2, self.y + self.h)
    else 
        self.sprite = 1
    end
    if self.vely == 0 then
        self.jump_c = 0
    end
end
