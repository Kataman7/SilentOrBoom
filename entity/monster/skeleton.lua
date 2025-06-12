Skull = Monster:new()

function Skull:new(x, y)
    local obj = Monster.new(self, x, y, 8, 8)
    obj.speed = rnd(0.005) + 0.13
    obj.jump_force = 2
    obj.detection_range = rnd(10) + 100
    obj.distance_securite = rnd(5) + 50
    obj.attack_cooldown = 180 - player.stage
    obj.life = 15 + player.stage * 2
    obj.attack_damage = 1 + player.stage
    obj.sprite_idle = 28
    obj.sprite_walk = {29, 30}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Skull:update_ai()
    if self:get_distance_to(player) < self.detection_range and self:get_distance_to(player) > self.distance_securite then
        if self.x < player.x - 1 then
            self.velx = self.velx + self.speed
        elseif self.x > player.x + 1 then
            self.velx = self.velx - self.speed
        else
            if self.jump_counter < 1 then
                self.vely = -self.jump_force
                self.jump_counter = self.jump_counter + 1
            end
        end
    end
    if self:get_distance_to(player) < self.distance_securite + 1 then
        if self.x < player.x - 1 then
            self.velx = self.velx - self.speed
        elseif self.x > player.x + 1 then
            self.velx = self.velx + self.speed
        else
            if self.jump_counter < 1 then
                self.vely = -self.jump_force
                self.jump_counter = self.jump_counter + 1
            end
        end
    end
end

function Skull:animate_walk()
    self.anim_frame += 1
    if self.anim_frame >= self.anim_speed then
        self.anim_frame = 0
        if self.sprite == self.sprite_walk[1] then
            self.sprite = self.sprite_walk[2]
        else
            self.sprite = self.sprite_walk[1]
        end
    end
    if effects and effects.walk then
        effects:walk(self.x + self.w / 2, self.y + self.h)
    end
end

function Skull:update_attack()
    -- Skull attaque à distance
    if self:get_distance_to(player) < self.detection_range then
        if self.attack_cooldown <= 0 then
            add(tirs, Tir:new(self.x, self.y))
            self.attack_cooldown = 180 - player.stage
        end
    end
    if self.attack_cooldown > 0 then
        self.attack_cooldown = self.attack_cooldown - 1
    end
end