Zombie = Monster:new()

function Zombie:new(x, y)
    local obj = Monster.new(self, x, y, 8, 8)
    obj.speed = rnd(0.005) + 0.13
    obj.jump_force = 2
    obj.detection_range = rnd(10) + 100
    obj.attack_cooldown = 70 - flr(player.stage / 5)
    obj.life = 10 + player.stage * 1.5
    obj.attack_damage = 1
    obj.sprite_idle = 10
    obj.sprite_walk = {11, 12}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Zombie:update_ai()
    if self:get_distance_to(player) < self.detection_range then
        if self.x < player.x - 1 then
            self.velx = self.velx + self.speed
            -- Saut si bloqué à droite
            if self:check_collision(self.x + self.velx, self.y) and self.jump_counter < 1 then
                self.vely = -self.jump_force
                self.jump_counter = self.jump_counter + 1
            end
        elseif self.x > player.x + 1 then
            self.velx = self.velx - self.speed
            -- Saut si bloqué à gauche
            if self:check_collision(self.x + self.velx, self.y) and self.jump_counter < 1 then
                self.vely = -self.jump_force
                self.jump_counter = self.jump_counter + 1
            end
        else
            if self.jump_counter < 1 then
                self.vely = -self.jump_force
                self.jump_counter = self.jump_counter + 1
            end
        end
    end
end

function Zombie:animate_walk()
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