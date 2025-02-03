GameLoop = Scene:new()

function GameLoop:new()
    local obj = Scene:new(self)
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function GameLoop:init()
    self.player = Player:new()
    self.camera = Camera:new(self.player)
    self.gui = Gui:new()
    self.effects = Effects:new()
    self.tnts = {}
    self.enemies = {}
    self.bullets = {}
end

function GameLoop:update()
    self.player:update()
    self.gui:update()
    self.camera:update()
    self.effects:update()

    updateEntities(self.tnts)
    updateEntities(self.enemies)
    updateEntities(self.bullets)
end

function GameLoop:draw()
    self.camera:draw()
    cls(12)
    self.player:draw()
    drawEntities(self.enemies)
    drawEntities(self.bullets)
    drawEntities(self.tnts)
    map()
    drawEntities(self.effects)
    self.gui:draw()
end

function updateEntities(array)
    for i = #array, 1, -1 do
        local entity = array[i]
        entity:update()
        if entity.sprite == 0 then
            del(array, entity)
        end
    end
end

function drawEntities(array)
    for entity in all(array) do
        entity:draw()
    end
end


