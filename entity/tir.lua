Tir = Entity:new()

function Tir:new(x, y)
    local obj = Entity.new(self, x, y, 4, 4, 0, 0, 0, 31)  -- 31 est le sprite du tir
    obj.speed = 0.5  -- Vitesse du tir
    obj:direction()
    obj.life=1
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Tir:direction()
    -- Calcul de la direction vers le joueur
    local dx = player.x - self.x  -- Différence en x
    local dy = player.y - self.y  -- Différence en y
    local distance = sqrt(dx * dx + dy * dy)  -- Distance entre le tir et le joueur

    -- Normalisation de la direction et application de la vitesse
    if distance > 0 then
        self.velx = (dx / distance) * self.speed  -- vx normalisé * vitesse
        self.vely = (dy / distance) * self.speed  -- vy normalisé * vitesse
    else
        self.velx = 0
        self.vely = 0
    end
end

function Tir:update()
    local new_y = self.y + self.vely

    if not self:check_collision(self.x, new_y) then
        self.y = new_y
    else
        self.life = 0
    end

    local new_x = self.x + self.velx
    
    if (abs(self.velx) < 0.1) then
        self.velx = 0
    end

    if not self:check_collision(new_x, self.y) then
        self.x = new_x
    else
        self.life = 0
    end

    -- Collision avec le joueur
    if self:get_distance_to(player) < 8 then  -- 8 est une distance arbitraire pour la collision
        player.life = player.life - 1  -- Le joueur perd une vie
        self.life = 0  -- Le tir disparaît
    end

    -- Suppression du tir s'il sort de l'écran
    if self.x < -100 or self.x > 500 or self.y < -100 or self.y > 300 then
        self.life = 0
    end

    -- Mort du tir
    if self.life <= 0 then
        self.sprite = 0
    end
end