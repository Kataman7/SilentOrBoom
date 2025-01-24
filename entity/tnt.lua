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