Effects = {}

function Effects:new()
    local obj = {
        particles = {}
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Effects:update()
    for particul in all(self.particles) do
        particul:update()
    end
end

function Effects:draw()
    for particul in all(self.particles) do
        particul:draw()
        self:delete_if_deletable(particul)
    end
end

function Effects:delete_if_deletable(particul)
    if (particul.frame <= 0) then
        particul.radius = particul.radius - 0.1
    end

    if (particul.frame <= 0 and particul.radius <= 1) or (particul.x > dcam.x + 64 or particul.x < dcam.x - 64 or particul.y > dcam.y + 64 or particul.y < dcam.y - 64) then
        del(self.particles, particul)
    end
end

function Effects:explosion(x, y)
    for i = 1, 20 do
        local angle = rnd(1) * 2 * 3.14159
        local speed = rnd(1) * 2
        local radius = rnd(1) * 7
        local color = rnd({1,2,3,4,5,6,7,8,9,10,11,13,14,15})
        local particule = Particul:new(x, y, radius, cos(angle) * speed, sin(angle) * speed, color)
        add(self.particles, particule)
    end
end

function Effects:clear()
    self.particles = {}
end

function Effects:walk(x, y)
    if rnd(1) < 0.2 then
        local angle = rnd(1) * 0.5 * 3.14159 -- Limiting angle to only go upwards
        local speed = rnd(1) * 0.2
        local radius = rnd(1) * 2
        local color = rnd({7,6})
        local particule = Particul:new(x, y, radius, cos(angle) * speed, sin(angle) * speed, color, 1)
        add(self.particles, particule)
    end
end

function Effects:jump(x, y)
    for i = 1, 10 do
        local angle = rnd(1) * 2 * 3.14159
        local speed = rnd(1) * 0.5
        local radius = rnd(1) * 2
        local color = rnd({7,7,7,6})
        local particule = Particul:new(x, y, radius, cos(angle) * speed, sin(angle) * speed, color, 2)
        add(self.particles, particule)
    end
end

function Effects:blood(x, y)
    for i = 1, 15 do
        local angle = rnd(1) * 1 * 3.14159 + 3.14159 -- Orienting particles to the left
        local speed = rnd(1)
        local radius = rnd(1) * 1
        local color = rnd({8,8,8,2,2,13,14})
        local particule = Particul:new(x, y, radius, cos(angle) * speed, sin(angle) * speed, color, 0.5)
        add(self.particles, particule)
    end
end
    