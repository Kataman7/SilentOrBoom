Tnt = Entity:new()

function Tnt:new(x, y, power, range, tick)
    local obj = Entity.new(self, x, y, 8, 8, 0.2, 0.4, 0.85, 4)
    obj.power = power
    obj.range = range
    obj.tick = tick
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Tnt:update()
    Entity.update(self)

    self.tick -= 1

    if self.tick <= 1 then
        if self.power > 0 then
            self:propulse(player)
            self:destroyMap()
        end

        self.power = 0
        self.sprite = 0
    end
end

function Tnt:propulse(other)
    if self.power > 0 then
        effects:explosion(self.x + self.w / 2, self.y + self.h / 2)
            
        local dx = other.x - self.x
        local dy = other.y - self.y
        local dist = sqrt(dx * dx + dy * dy)

        if dist < self.range then
            -- Gérer le cas où la distance est nulle
            if dist == 0 then
                -- Direction par défaut vers le haut
                dx = 0
                dy = -1
                dist = 1  -- Évite la division par zéro
            end

            local force = self.power * (1 - dist / self.range)
            other.velx = other.velx + (dx / dist) * force
            other.vely = other.vely + (dy / dist) * force
        end
    end
end

function Tnt:destroyMap()

    -- Destruction de la map
    local center_mx = flr((self.x + 4) / 8) -- Position centre en tiles
    local center_my = flr((self.y + 4) / 8)
    local radius = flr(self.range / 30) * 1.2 -- Rayon en tiles

    for dx = -radius, radius do
        for dy = -radius, radius do
            -- Vérification cercle avec Pythagore
            if dx*dx + dy*dy <= radius*radius then
                local mx = center_mx + dx
                local my = center_my + dy
                
                -- Vérification des limites de la map
                if mx >= 0 and mx < 128 and my >= 0 and my < 64 then
                    
                    mineral = mget(mx, my)

                    if (mineral == 34 or mineral == 55 or mineral == 57 or mineral == 41) then
                        
                    end

                    mset(mx, my, 0)
                end
            end
        end
    end
end