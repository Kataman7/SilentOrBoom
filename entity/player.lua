Player = Entity:new()

function Player:new()
    local obj = Entity.new(self, 64, 64, 8, 8, 0.2, 0.4, 0.85, 1)
    obj.jump_f = 5
    obj.jump_c = 0
    obj.jump_m = 2
    obj.anim_frame = 0
    obj.anim_speed = 10
    obj.life = 50
    obj.mineral = 0
    obj.tntPower = 10
    obj.tntRange = 100
    obj.tntSpeed = 100
    obj.stage = 0
    obj.tntDelayMax = 60 * 4
    obj.tntDelay = obj.tntDelayMax
    obj.mineral_mult = 1
    obj.bonus_stage = 0
    obj.boss_tuer = 0
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Player:tnt()

    if self.tntDelay > 0 then
        return
    end

    local tnt = Tnt:new(self.x, self.y, self.tntPower, self.tntRange, self.tntSpeed)
    tnt.vely = -2;
    add(tnts, tnt)
    self.tntDelay = self.tntDelayMax
end

function Player:control()

    self.tntDelay = self.tntDelay - 1
    if self.tntDelay < 0 then
        self.tntDelay = 0
    end

    if btn(1) then
        self.velx = self.velx + self.speed
    end
    if btn(0) then
        self.velx = self.velx - self.speed
    end
    if btnp(2) or btnp(4) then
        effects:jump(self.x + self.w / 2, self.y + self.h)
        if self.jump_c < self.jump_m then
            self.vely = -self.jump_f
            self.jump_c = self.jump_c + 1
        end
    end
    if btnp(5) then
        player:tnt()
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
