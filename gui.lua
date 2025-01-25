GUI = {}
local base = -58
function GUI:new()
    local obj = {
        vie = {
            sprite = 5,
            x = -60,
            y = base,
            valeur = player.life
        },
        mineral = {
            sprite = 6,
            x = -60,
            y = base + 8,
            valeur = player.mineral,
            anim_frame = 0,
            anim_speed = 60
        },
        stage = {
            sprite = 23,
            x = -60,
            y = base + 16,
            valeur = player.stage
        },
        tntDelay = {
            sprite = 64,
            x = -60,
            y = base + 24,
            valeur = player.tntDelay,
            anim_frame = 0,
            anim_speed = 10
        },
        timer = {
            sprite = 4,
            x = -60,
            y = base + 32,
            valeur = 0,
            tic = 0
        },
        intro = 0
    }
    setmetatable(obj, self)
    self.__index = GUI
    return obj
end

function GUI:update()
    
    if self.intro < 3 then
        if btnp(4) or btnp(5) then
            self.intro = self.intro + 1
        end
    end

    self.vie.valeur = player.life
    self.mineral.valeur = player.mineral
    self.stage.valeur = player.stage
    self.tntDelay.valeur = player.tntDelay
    self.timer.tic = self.timer.tic + 1
    if self.timer.tic >= 60 then
        self.timer.valeur = self.timer.valeur + 1
        self.timer.tic=0
    end
    self.mineral.anim_frame = self.mineral.anim_frame + 1
    if self.mineral.anim_frame >= self.mineral.anim_speed then
        self.mineral.anim_frame = 0
        if self.mineral.sprite == 6 then
            self.mineral.sprite = 7
        elseif self.mineral.sprite == 7 then
            self.mineral.sprite = 8
        elseif self.mineral.sprite == 8 then
            self.mineral.sprite = 9
        elseif self.mineral.sprite == 9 then
            self.mineral.sprite = 22
        else
            self.mineral.sprite = 6
        end
    end
    
    self.tntDelay.anim_frame += 1
    if self.tntDelay.anim_frame >= self.tntDelay.anim_speed then
        self.tntDelay.anim_frame = 0
        if self.tntDelay.sprite == 64 then
            self.tntDelay.sprite = 65
        elseif self.tntDelay.sprite == 64 then
            self.tntDelay.sprite = 65
        elseif self.tntDelay.sprite == 65 then
            self.tntDelay.sprite = 66
        elseif self.tntDelay.sprite == 66 then
            self.tntDelay.sprite = 67
        elseif self.tntDelay.sprite == 67 then
            self.tntDelay.sprite = 68
        elseif self.tntDelay.sprite == 68 then
            self.tntDelay.sprite = 69
        elseif self.tntDelay.sprite == 69 then
            self.tntDelay.sprite = 70
        elseif self.tntDelay.sprite == 70 then
            self.tntDelay.sprite = 71
        else
            self.tntDelay.sprite = 64
        end
    end  
    
    if self.tntDelay.valeur>0 then
        self.tntDelay.sprite=64
    end
end

function GUI:draw()
    local offset_x = dcam.x
    local offset_y = dcam.y

    spr(self.vie.sprite, self.vie.x + offset_x, self.vie.y + offset_y)
    print(self.vie.valeur, self.vie.x + 10 + offset_x, self.vie.y + offset_y + 2, 7)
    spr(self.mineral.sprite, self.mineral.x + offset_x, self.mineral.y + offset_y)
    print(self.mineral.valeur, self.mineral.x + 10 + offset_x, self.mineral.y + offset_y + 2, 7)
    spr(self.stage.sprite, self.stage.x + offset_x, self.stage.y + offset_y)
    print(self.stage.valeur, self.stage.x + 10 + offset_x, self.stage.y + offset_y + 2, 7)
    spr(self.tntDelay.sprite, self.tntDelay.x + offset_x, self.tntDelay.y + offset_y)
    print(self.tntDelay.valeur, self.tntDelay.x + 10 + offset_x, self.tntDelay.y + offset_y + 2, 7)
    spr(self.timer.sprite, self.timer.x + offset_x, self.timer.y + offset_y)
    print(self.timer.valeur, self.timer.x + 10 + offset_x, self.timer.y + offset_y + 2, 7)

end

function GUI:displayGameOver()
    
    dcam:resets()
    print("GAME OVER", 50, 64, 7)
end

function GUI:displayIntro()
    dcam:resets()
    if self.intro == 0 then
        -- life was sweet. nothing could disturb my inner peace. except, perhaps... blasting music from the neighbors.
        print("life was sweet.", 0, 44, 7)  -- 64 - 20
        print("nothing could disturb", 0, 52, 7)  -- 72 - 20
        print("my inner peace.", 0, 60, 7)  -- 80 - 20
        print("except, perhaps...", 0, 68, 7)  -- 88 - 20
        print("blasting music from", 0, 76, 8)  -- 96 - 20
        print("the neighbors.", 0, 84, 8)  -- 104 - 20
    elseif self.intro == 1 then
        -- their music was so loud it woke up my cat, my plants, and even my old memories of metal festivals. that was the last straw.
        print("their music was so loud", 0, 44, 7)  -- 64 - 20
        print("it woke up my cat,", 0, 52, 7)  -- 72 - 20
        print("my plants, and even", 0, 60, 7)  -- 80 - 20
        print("my old memories of", 0, 68, 7)  -- 88 - 20
        print("metal festivals.", 0, 76, 7)  -- 96 - 20
        print("that was the last straw.", 0, 84, 7)  -- 104 - 20
    elseif self.intro == 2 then
        -- i brought out my tnt. not out of anger, but out of necessity. because silence is a right, and i was determined to reclaim it.
        print("i brought out my ", 0, 44, 7)  -- 64 - 20
        print("tnt", 66, 44, 8)  -- "TNT" en rouge
        print(".", 78, 44, 7)  -- 64 - 20
        print("not out of anger,", 0, 52, 7)  -- 72 - 20
        print("but out of necessity.", 0, 60, 7)  -- 80 - 20
        print("because ", 0, 68, 7)  -- 88 - 20
        print("silence", 31, 68, 12)  -- "silence" en bleu
        print(" is a", 58, 68, 7)  -- 88 - 20
        print("right, and i was", 0, 76, 7)  -- 96 - 20
        print("determined to reclaim it.", 0, 84, 7)  -- 104 - 20
    end
end

function GUI:displayWin()
    dcam:resets()
    print("YOU WIN", 50, 64, 7)
end