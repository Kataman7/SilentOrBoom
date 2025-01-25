Wave = {}

function Wave:new(x, y, radius, speed, color, frame)
    local obj = {
        x = x or 0,
        y = y or 0,
        radius = radius or 5,  -- Rayon initial
        speed = speed or 0.5,  -- Vitesse d'expansion
        color = color or 7,    -- Couleur du cercle
        frame = (frame and frame * 60) or 2 * 60  -- Durée de vie (2 secondes par défaut)
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Wave:update()
    self.radius = self.radius + self.speed  -- Agrandir le rayon
    self.frame = self.frame - 1             -- Réduire la durée de vie
end

function Wave:draw()
    circ(self.x, self.y, self.radius, self.color)  -- Dessiner un cercle vide
end