Player = Entity:new()

function Player:new()
    local obj = Entity:new(64, 64, 8, 8, 0.2, 0.4, 0.85, 117)
    obj.jump_f = 5
    obj.jump_c = 0
    obj.jump_m = 4
    obj.life = 100
    obj.mineral = 0
    obj.tntPower = 20
    obj.tntSpeed = 80
    obj.stage = 0
    obj.tntDelayMax = 60
    obj.tntDelay = obj.tntDelayMax
    obj.mineral_mult = 1
    obj.bonus_stage = 0
    obj.boss_tuer = 0
    obj.anim_walk = Animation:new(nil, nil, 40, {118, 119})
    obj.fliped = true

    
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Player:tnt()

    if self.tntDelay > 0 then
        return
    end

    local tnt = Tnt:new(self.x, self.y, self.tntPower, self.tntSpeed)
    tnt.vely = -2;
    add(tnts, tnt)
    self.tntDelay = self.tntDelayMax
end

function Player:control()

    self.tntDelay = self.tntDelay - 1
    if self.tntDelay < 0 then
        self.tntDelay = 0
    end

    if btn(1) then
        self.velx = self.velx + self.speed
    end
    if btn(0) then
        self.velx = self.velx - self.speed
    end
    if btnp(2) or btnp(4) then
        effects:jump(self.x + self.w / 2, self.y + self.h)
        if self.jump_c < self.jump_m then
            self.vely = -self.jump_f
            self.jump_c = self.jump_c + 1
        end
    end
    if btnp(5) then
        player:tnt()
    end
end

function Player:update()
    self:control()
    Entity.update(self)

    if self.velx ~= 0 and self.vely == 0 then
        self.anim_walk:update()
        self.sprite = self.anim_walk.sprite
        effects:walk(self.x + self.w / 2, self.y + self.h)
    else 
        self.sprite = 117
    end
    if self.vely == 0 then
        self.jump_c = 0
    end

    if self.y > 64*8 + 48 then
        if self.boss_tuer >= 2 then
            scenes.endScene.gui.win = true
            changeScene(scenes.endScene)
            return
        end
        self.stage += 1
        self.y = -32
        -- On le replace au centre (64*8) pour être sûr qu'il atterrisse sur l'île
        self.x = 64 * 8
        self.vely = 2
        
        if player.mineral >= 5 then -- valeur de base pour l'upgrade
            if current_scene ~= scenes.upgradeMenu then
                changeScene(scenes.upgradeMenu)
            end
        else
            -- On force un petit état de chargement si possible ou on génère
            generate_world()
            changeScene(scenes.gameLoop)
        end
    end

    if self.life <= 0 then
        if current_scene ~= scenes.endScene then
            self.life = 0
            self.velx = 0
            self.vely = 0
            changeScene(scenes.endScene)
        end
    end
end
