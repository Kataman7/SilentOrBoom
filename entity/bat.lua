Bat = Entity:new()

function Bat:new(x,y)
    local speed = rnd(0.005)+0.12
    local detection = rnd(10)+100
    local obj = Entity.new(self, x, y, 8, 8, speed, 0.2, 0.85, 13)
    obj.anim_frame = 0
    obj.anim_speed = 10
    obj.distance_detect = detection
    obj.speed_attack =  70 - flr(player.stage / 5)
    obj.life=15 + player.stage
    obj.attack = 1 + flr(player.stage / 2)
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Bat:control()
    if self:get_distance_to(player)<self.distance_detect then
        if self.x<player.x-1 then
            self.velx = self.velx + self.speed
        elseif self.x>player.x+1 then
            self.velx = self.velx - self.speed
        end
        if self.y<player.y-1 then
            self.vely = self.vely + self.speed
        elseif self.y>player.y+1 then
            self.vely = self.vely - self.speed
        end
    end
end


function Bat:update()
    self:control()

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
    self.anim_frame += 1
    if self.anim_frame >= self.anim_speed then
        self.anim_frame = 0
        if self.sprite == 26 then
            self.sprite = 27
        else
            self.sprite = 26
        end
    end    
    effects:walk(self.x + self.w / 2, self.y + self.h)

    -- Attaque
    if self:check_entity_collision(player) then
        if self.speed_attack<=0 then
            effects:blood(self.x + self.w / 2, self.y + self.h)
            self.speed_attack= 70 - flr(player.stage / 5)
            player.life=player.life-self.attack
        end
    end


    --Friction et déplacement temporaire
    self.velx = self.velx * self.frict
    self.vely = self.vely * self.frict
    local new_x = self.x + self.velx
    local new_y = self.y + self.vely

    --Déplacment après chek des collision
    if not self:check_collision(self.x, new_y) then
        self.y = new_y
    else
        self.vely = 0
    end

    if self.x ~= new_x then
        if not self:check_collision(new_x, self.y) then
            self.x = new_x
        else
            if self.velx > 50 then
                self.velx = self.velx * -0.5
            else
                self.velx = 0
            end
        end
    end
    
    --Arret
    if (abs(self.velx) < 0.1) then
        self.velx = 0
    end
    if (abs(self.vely) < 0.1) then
        self.vely = 0
    end

    --Mort!
    if (self.life<=0) then
        self.sprite = 0
    end
end