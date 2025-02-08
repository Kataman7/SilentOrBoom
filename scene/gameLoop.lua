GameLoop = Scene:new()

function GameLoop:new()
    local obj = Scene:new(self)
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function GameLoop:init()
    self.gui = GameStats:new()
    self.enemies = {}
    self.bullets = {}
end

function GameLoop:update()
    player:update()
    self.gui:update()
    dcam:update()
    effects:update()

    updateEntities(tnts)
    updateEntities(self.enemies)
    updateEntities(self.bullets)
end

function GameLoop:draw()
    dcam:draw()
    cls(12)
    player:draw()
    drawEntities(self.enemies)
    drawEntities(self.bullets)
    drawEntities(tnts)
    map()
    effects:draw()
    self.gui:draw()
end


