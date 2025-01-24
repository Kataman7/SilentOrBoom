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
            valeur = player.mineral
        },
        stage = {
            sprite = 23,
            x = -60,
            y = base + 16,
            valeur = player.stage
        },
        tntDelay = {
            sprite = 4,
            x = -60,
            y = base + 24,
            valeur = player.tntDelay
        }

    }
    setmetatable(obj, self)
    self.__index = GUI
    return obj
end

function GUI:update()
    self.vie.valeur = player.life
    self.mineral.valeur = player.mineral
    self.stage.valeur = player.stage
    self.tntDelay.valeur = player.tntDelay
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
    print(player.x .. " " .. player.y, self.tntDelay.x + 10 + offset_x, self.tntDelay.y + offset_y + 2, 7)
end