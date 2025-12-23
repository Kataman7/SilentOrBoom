Spider = Monster:new()

function Spider:new(x, y)
    local obj = Monster.new(self, x, y, 8, 8)
    obj.speed = rnd(0.005) + 0.13
    obj.jump_force = 3
    obj.detection_range = rnd(10) + 100
    obj.attack_cooldown = 70 - flr(player.stage / 5)
    obj.life = 10 + player.stage
    obj.attack_damage = 1 + flr(player.stage / 10)
    obj.sprite_idle = 13
    obj.sprite_walk = {14, 15}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Spider:update_ai()
    if self:get_distance_to(player) < self.detection_range then
        if self.x < player.x - 1 then
            self.velx = self.velx + self.speed
        elseif self.x > player.x + 1 then
            self.velx = self.velx - self.speed
        else
            if self.jump_counter < 1 then
                self.vely = self.jump_force
                self.jump_counter = self.jump_counter + 1
            end
        end
    end
end

function Spider:update_movement()
    -- Spider saute vers le haut (gravité inversée)
    self.vely = self.vely - self.gravity
    self.y = self:resolve_vertical_collision(self.y + self.vely)
    self.velx = self.velx * self.frict
    self.x = self:resolve_horizontal_collision(self.x + self.velx)
end