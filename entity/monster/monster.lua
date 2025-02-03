Monster = Entity:new()

function Monster:new(x, y, w, h)
    if self == Monster then
        print("Monster is abstract and cannot be instantiated directly", 2)
    end
    
    local obj = Entity.new(self, x, y, w or 8, h or 8, 0, 0.2, 0.85, 10)
    obj:init_monster()
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Monster:init_monster()
    -- Propriétés de base (peuvent être surchargées)
    self.speed = 0
    self.jump_force = 2
    self.jump_counter = 0
    self.detection_range = 100
    self.attack_cooldown = 0
    self.attack_damage = 1
    self.life = 10
    
    -- Animation
    self.anim_frame = 0
    self.anim_speed = 10
    self.sprite_idle = 10
    self.sprite_walk = {11, 12}
end

function Monster:update()
    self:update_ai()         -- Méthode abstraite
    self:update_movement()
    self:update_collisions()
    self:update_jump()
    self:update_death()
    self:update_animation()  -- Partiellement abstraite
    self:update_attack()
end

----------------------------------------------------------------
-- Méthodes abstraites (doivent être implémentées)
----------------------------------------------------------------

function Monster:update_ai()
    error("update_ai() must be implemented in subclass", 2)
end

function Monster:animate_walk()
    error("animate_walk() must be implemented in subclass", 2)
end

----------------------------------------------------------------
-- Méthodes concrètes (peuvent être surchargées si nécessaire)
----------------------------------------------------------------

function Monster:update_movement()
    self.vely = self.vely + self.gravity
    self.y = self:resolve_vertical_collision(self.y + self.vely)
    
    self.velx = self.velx * self.frict
    self.x = self:resolve_horizontal_collision(self.x + self.velx)
end

function Monster:resolve_vertical_collision(new_y)
    if not self:check_collision(self.x, new_y) then
        return new_y
    else
        self.vely = 0
        return self.y
    end
end

function Monster:resolve_horizontal_collision(new_x)
    if self:check_collision(new_x, self.y) then
        self:handle_horizontal_collision()
        return self.x
    end
    return new_x
end

function Monster:handle_horizontal_collision()
    if self.velx > 50 then
        self.velx = self.velx * -0.5
    else
        self.velx = 0
    end
end

function Monster:update_jump()
    if self.vely == 0 then
        self.jump_counter = 0
    end
end

function Monster:update_death()
    if self.y > 300 or self.y < -100 then
        self.life = 0
    end
    if self.life <= 0 then
        self.sprite = 0
    end
end

function Monster:update_animation()
    if self.velx ~= 0 and self.vely == 0 then
        self:animate_walk() -- Appel de la méthode abstraite
    else
        self:animate_idle()
    end
end

function Monster:animate_idle()
    self.sprite = self.sprite_idle
end

function Monster:update_attack()
    if self:check_entity_collision(player) then
        self:perform_attack()
    end
    
    if self.attack_cooldown > 0 then
        self.attack_cooldown = self.attack_cooldown - 1
    end
end

function Monster:perform_attack()
    if self.attack_cooldown <= 0 then
        self:attack_effect()
        self.attack_cooldown = 70 - flr(player.stage / 5)
        player.life = player.life - self.attack_damage
    end
end

function Monster:attack_effect()
    scenes.gameLoop.effects:blood(self.x + self.w/2, self.y + self.h)
end