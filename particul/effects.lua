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
        
        if particul.x > dcam.x + 64 or particul.x < dcam.x - 64 or particul.y > dcam.y + 64 or particul.y < dcam.y - 64 then
            del(self.particles, particul)
        end
    end
end

function Effects:explosion(x, y)
    for i = 1, 20 do
        local angle = rnd(1) * 2 * 3.14159
        local speed = rnd(1) * 2
        local radius = rnd(1) * 5
        local color = rnd({1,2,3,4,5,6,7,8,9,10,11,13,14,15})
        local particule = Particul:new(x, y, radius, cos(angle) * speed, sin(angle) * speed, color)
        add(self.particles, particule)
    end
end

function Effects:clear()
    self.particles = {}
end

function Effects:walk(x, y)
    for i = 1, 1 do
        local angle = rnd(1) * 2 * 3.14159
        local speed = rnd(1) * 0.2
        local radius = rnd(1) * 2
        local color = rnd({7,7,7,6})
        local particule = Particul:new(x, y, radius, cos(angle) * speed, sin(angle) * speed, color)
        add(self.particles, particule)
    end
end
    
