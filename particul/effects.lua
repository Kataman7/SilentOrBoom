Effects = {}

function Effects:new()
    local obj = {
        particles = {},
        waves = {}  -- Nouvelle table pour stocker les ondes
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Effects:update()
    -- Mettre à jour les particules
    for particul in all(self.particles) do
        particul:update()
    end

    -- Mettre à jour les ondes
    for wave in all(self.waves) do
        wave:update()
    end
end

function Effects:draw()
    -- Dessiner les particules
    for particul in all(self.particles) do
        particul:draw()
        self:delete_if_deletable(particul)
    end

    -- Dessiner les ondes
    for wave in all(self.waves) do
        wave:draw()
        self:delete_if_deletable(wave)
    end
end

function Effects:delete_if_deletable(obj)
    if obj.frame <= 0 then
        if obj.radius then  -- Si c'est une onde
            del(self.waves, obj)
        else  -- Si c'est une particule
            del(self.particles, obj)
        end
    end
end

function Effects:speaker_waves(x, y)
    for i = 1, 3 do  -- Générer 3 ondes concentriques
        local radius = 5 + i * 5  -- Rayon initial
        local speed = 0.5         -- Vitesse d'expansion
        local color = 7           -- Couleur du cercle
        local frame = 120          -- Durée de vie (2 secondes)

        local wave = Wave:new(x, y, radius, speed, color, frame)
        add(self.waves, wave)  -- Ajouter l'onde à la table des ondes
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