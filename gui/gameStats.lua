GameStats = Gui:new()
local base = -58
function GameStats:new()
    local obj = Gui.new(self)
        obj.vie = {
            sprite = 5,
            x = -60,
            y = base,
            valeur = player.life
        }
        obj.mineral = {
            sprite = 6,
            x = -60,
            y = base + 8,
            valeur = player.mineral,
            anim_frame = 0,
            anim_speed = 60
        }
        obj.stage = {
            sprite = 23,
            x = -60,
            y = base + 16,
            valeur = player.stage
        }
        obj.tntDelay = {
            sprite = 64,
            x = -60,
            y = base + 24,
            valeur = player.tntDelay,
            anim_frame = 0,
            anim_speed = 10
        }
        obj.timer = {
            sprite = 4,
            x = -60,
            y = base + 32,
            valeur = 0,
            tic = 0
        }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function GameStats:update()
    
    if self.intro < 3 then
        if btnp(4) or btnp(5) then
            self.intro = self.intro + 1
        end
    end

    self.vie.valeur = player.life
    self.mineral.valeur = player.mineral
    self.stage.valeur = player.stage
    self.tntDelay.valeur = player.tntDelay
end

function GameStats:draw()
    
    spr(self.vie.sprite, self.vie.x + dcam.x, self.vie.y + offset_y)
    print(self.vie.valeur, self.vie.x + 10 + dcam.x, self.vie.y + offset_y + 2, 7)
    spr(self.mineral.sprite, self.mineral.x + dcam.x, self.mineral.y + offset_y)
    print(self.mineral.valeur, self.mineral.x + 10 + dcam.x, self.mineral.y + offset_y + 2, 7)
    spr(self.stage.sprite, self.stage.x + dcam.x, self.stage.y + offset_y)
    print(self.stage.valeur, self.stage.x + 10 + dcam.x, self.stage.y + offset_y + 2, 7)
    spr(self.tntDelay.sprite, self.tntDelay.x + dcam.x, self.tntDelay.y + offset_y)
    print(self.tntDelay.valeur, self.tntDelay.x + 10 + dcam.x, self.tntDelay.y + offset_y + 2, 7)
    spr(self.timer.sprite, self.timer.x + dcam.x, self.timer.y + offset_y)
    print(self.timer.valeur, self.timer.x + 10 + dcam.x, self.timer.y + offset_y + 2, 7)

end