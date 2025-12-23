Tnt = Entity:new()

function Tnt:new(x, y, power, tick)
    local obj = Entity.new(self, x, y, 8, 8, 0.2, 0.4, 0.85, 64)
    obj.power = power
    obj.range = 40
    obj.tick = tick
    obj.anim_frame = 0
    obj.anim_speed = 10
    obj.anim = TntAnim:new(true) -- Correction ici (T majuscule)
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Tnt:update()
    Entity.update(self)
    self.tick -= 1
    if self.anim then
        self.anim:update()
    end

    if self.tick <= 1 then
        if self.power > 0 then
            self:propulse(player)
            if scenes and scenes.gameLoop and scenes.gameLoop.enemies then
                for monstre in all(scenes.gameLoop.enemies) do
                    self:propulse(monstre, true)
                end
            end
            self:destroyMap()
            effects:explosion(self.x + self.w / 2, self.y + self.h / 2)
        end

        self.power = 0
        self.sprite = 0
    end 
end

function Tnt:draw()
    if self.sprite ~= 0 then
        if self.anim then
            spr(self.anim.sprite, self.x, self.y)
        else
            spr(self.sprite, self.x, self.y)
        end
    end
end

function Tnt:propulse(other, damage)
    if other == nil then
        return
    end

    local dx = other.x - self.x
    local dy = other.y - self.y
    
    if abs(dx) > self.range or abs(dy) > self.range then
        return
    end

    local dist = sqrt(dx * dx + dy * dy)

    if dist < self.range then
        -- Gérer le cas où la distance est nulle
        if dist == 0 then
            dx = 0
            dy = -1
            dist = 1
        end

        if not other.explosion_resistance then
            local force = self.power * 0.3 * (1 - dist / self.range)
            other.velx = other.velx + (dx / dist) * force
            other.vely = other.vely + (dy / dist) * force
        end

        if damage then
            local dmg = self.power * (1 - dist / self.range)
            other.life -= dmg
            effects:blood(other.x, other.y)
        end
    end
end

function Tnt:destroyMap()

    -- Destruction de la map
    local center_mx = flr((self.x + 4) / 8) -- Position centre en tiles
    local center_my = flr((self.y + 4) / 8)
    local radius = flr(self.range / 10) -- Rayon en tiles (un peu moins que le range pixel)
    local r2 = radius * radius

    for dx = -radius, radius do
        local dxx = dx * dx
        local mx = center_mx + dx
        if mx >= 0 and mx < 128 then
            for dy = -radius, radius do
                if dxx + dy * dy <= r2 then
                    local my = center_my + dy
                    if my >= 0 and my < 64 then
                        local tile = mget(mx, my)
                        if tile != 0 then
                            if fget(tile, 2) then
                                player.mineral += player.mineral_mult
                            end
                            if not fget(tile, 1) then 
                                mset(mx, my, 0)
                            end
                        end
                    end
                end
            end
        end
    end
end