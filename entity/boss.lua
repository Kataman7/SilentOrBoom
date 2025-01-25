Boss = Entity:new()

function Boss:new(x,y,boss)
    local speed = 0.14
    local detection = 1000
    local obj = Entity.new(self, x, y, 58, 16, speed, 0.2, 0.85, 45)
    obj.jump_f = 4
    obj.jump_c = 0
    obj.anim_frame = 0
    obj.anim_speed = 10
    obj.distance_detect = detection
    obj.speed_attack = 60
    obj.life = 1500
    obj.boss=boss
    obj.phase=0
    obj.phase_frame=0
    obj.phase_changement=0
    obj.explosion_resistance=true
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Boss:control()
    if player.x<480 or #monstres==1 then
        if self.x<player.x-1 then
            self.velx = self.velx + self.speed
        elseif self.x>player.x+1 then
            self.velx = self.velx - self.speed
        end
    else
        if self.x+42<player.x-1 then
            self.velx = self.velx + self.speed
        elseif self.x+42>player.x+1 then
            self.velx = self.velx - self.speed
        end
    end
end


function Boss:update()

    if self.boss~=0 and #monstres==1 then
        self.boss=0
    end

    -- Mort si sortie du jeu
    if self.y>300 or self.y<-100 then
        self.life=0
    end

    -- Mort
    if self.life==0 then
        self.sprite=0
        player.boss_tuer=player.boss_tuer+1
        return
    end


    -- Reduction du compteur entre deux attaques
    if self.speed_attack>0 then
        self.speed_attack=self.speed_attack-1
    end

    -- Attaque
    if self:check_entity_collision(player) then
        if self.speed_attack<=0 then
            effects:blood(self.x + self.w / 2, self.y + self.h)
            self.speed_attack=60
            player.life=player.life-3
        end
    end

    --Mort!
    if (self.life<=0) then
        self.sprite = 0
        player.boss_tuer=player.boss_tuer+1
    end

    if self.boss~=0 then
        self.x=self.boss.x+42
        self.y=self.boss.y
        return
    end


    self.phase_changement = self.phase_changement + 1

    -- Changement de phase après 340 itérations
    if self.phase_changement == 340 then
        if self.phase == 0 then
            self.phase = 1
            self.phase_frame = 0
        else
            self.phase = 0
        end
        self.phase_changement = 0
    end
    
    -- Logique en fonction de la phase
    if self.phase == 0 then
        self:control() -- Appel de la méthode de contrôle en phase 0
    else
        self.phase_frame = self.phase_frame + 1
    
        -- Gestion du saut en phase 1
        if self.phase_frame < 10 then
            self.vely = -self.jump_f -- Montée
        elseif self.phase_frame == 10 then
            self.vely = 0 -- Arrêt en haut
        elseif self.phase_frame > 70 and self.phase_frame<75 then
            self.vely = self.jump_f -- Descente
        elseif self.phase_frame == 75 then
            effects:jump(player.x + player.w / 2, player.y + player.h)
            if player.jump_c < player.jump_m then
                player.vely = -5
                player.jump_c = player.jump_c + 1
            end
        elseif self.phase_frame > 85 then
            self.phase_frame = 0 -- Réinitialisation du compteur de frame
        else
            self:control() -- Appel de la méthode de contrôle entre les étapes
        end
    end
    --Copie de entity pour pouvoir sauter au bon moment
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
            else
                self.velx = 0
            end
        end
    end
end

function Boss:draw()
    if self.sprite ~= 0 then
        for i = 0, 1 do
            for j = 0, 1 do
                local sprite_index = self.sprite + i + j * 16
                local x = self.x + i * 8
                local y = self.y + j * 8
                spr(sprite_index, x, y)
            end
        end
    end
end

function Boss:check_entity_collision(other)
    return self.x+4 < other.x + other.w and
           self.x + self.w - 46 > other.x and
           self.y < other.y + other.h and
           self.y + self.h > other.y
end