Bat = Monster:new()

function Bat:new(x, y)
    local obj = Monster.new(self, x, y, 8, 8)
    obj.speed = rnd(0.005) + 0.12
    obj.detection_range = rnd(10) + 100
    obj.attack_cooldown = 70 - flr(player.stage / 5)
    obj.life = 8 + player.stage * 0.8
    obj.attack_damage = 1 + flr(player.stage / 2)
    obj.sprite_idle = 26
    obj.sprite_walk = {26, 27}
    obj.anim_speed = 6 -- Animation rapide pour les ailes
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Bat:update_ai()
    if self:get_distance_to(player) < self.detection_range then
        if self.x < player.x - 1 then
            self.velx = self.velx + self.speed
        elseif self.x > player.x + 1 then
            self.velx = self.velx - self.speed
        end
        if self.y < player.y - 1 then
            self.vely = self.vely + self.speed
        elseif self.y > player.y + 1 then
            self.vely = self.vely - self.speed
        end
    end
end

function Bat:update_movement()
    -- Bat se déplace librement (pas de gravité)
    self.velx = self.velx * self.frict
    self.vely = self.vely * self.frict
    local new_x = self.x + self.velx
    local new_y = self.y + self.vely

    if not self:check_collision(self.x, new_y) then
        self.y = new_y
    else
        self.vely = 0
    end

    if not self:check_collision(new_x, self.y) then
        self.x = new_x
    else
        self.velx = 0
    end

    if abs(self.velx) < 0.1 then self.velx = 0 end
    if abs(self.vely) < 0.1 then self.vely = 0 end
end