Zombie = Entity:new()

function Zombie:new(x,y)
    local speed = rnd(0.005)+0.13
    local detection = rnd(10)+100
    local obj = Entity.new(self, x, y, 8, 8, speed, 0.2, 0.85, 10)
    obj.jump_f = 2
    obj.jump_c = 0
    obj.anim_frame = 0
    obj.anim_speed = 10
    obj.distance_detect = detection
    obj.speed_attack = 70 - flr(player.stage / 5)
    obj.life = 15 + player.stage * 2
    obj.attack = 1
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Zombie:control()
    if self:get_distance_to(player)<self.distance_detect then
        if self.x<player.x-1 then
            self.velx = self.velx + self.speed
        elseif self.x>player.x+1 then
            self.velx = self.velx - self.speed
        else
            if self.jump_c < 1 then
                self.vely = -self.jump_f
                self.jump_c = self.jump_c + 1
            end
        end
    end
end


function Zombie:update()
    self:control()

    --Copie de entity pour pouvoir sauter au bon moment
    self.vely = self.vely + self.gravity
    local new_y = self.y + self.vely

    if not self:check_collision(self.x, new_y) then
        self.y = new_y
    else
        self.vely = 0
    end

    self.velx = self.velx * self.frict
    local new_x = self.x + self.velx
    
    if (abs(self.velx) < 0.1) then
        self.velx = 0
    end

    if self.x ~= new_x then
        if not self:check_collision(new_x, self.y) then
            self.x = new_x
        else
            if self.velx > 50 then
                self.velx = self.velx * -0.5
            elseif self:get_distance_to(player)<self.distance_detect then
                if self.jump_c < 1 then
                    self.vely = -self.jump_f
                    self.jump_c = self.jump_c + 1
                end
            else
                self.velx = 0
            end
        end
    end

    --Réinitialisation du saut
    if self.vely == 0 then
        self.jump_c = 0
    end

    -- Mort si sortie du jeu
    if self.y>300 or self.y<-100 then
        self.life=0
    end

    -- Mort
    if self.life==0 then
        self.sprite=0
        return
    end


    -- Reduction du compteur entre deux attaques
    if self.speed_attack>0 then
        self.speed_attack=self.speed_attack-1
    end

    -- Animation
    if self.velx ~= 0 and self.vely == 0 then
        self.anim_frame += 1
        if self.anim_frame >= self.anim_speed then
            self.anim_frame = 0
            if self.sprite == 11 then
                self.sprite = 12
            else
                self.sprite = 11
            end
        end    
        effects:walk(self.x + self.w / 2, self.y + self.h)
    else
        if self.vely==0 and self.velx==0 then
            self.sprite = 10
        end
    end

    -- Attaque
    if self:check_entity_collision(player) then
        if self.speed_attack<=0 then
            effects:blood(self.x,self.y)
            self.speed_attack=60
            player.life=player.life-self.attack
        end
    end

    --Mort!
    if (self.life<=0) then
        self.sprite = 0
    end
end