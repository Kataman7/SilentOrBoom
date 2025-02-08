IntroScene = Scene:new()

function IntroScene:new()
    local obj = Scene:new()

    obj.gui = IntroText:new()
    obj.gameStart = false

    player.x = 10*8
    player.y = 10*8
    dcam.target = {x = 14*8, y = 12*8, w = 8, h = 8}

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function IntroScene:update()
    if (self.gameStart) then
        player:update()
        updateEntities(tnts)
        effects:update()

        if player.y > 50*8 then
            changeScene(scenes.gameLoop)
            return
        end

    else 
        if btnp(4) or btnp(5) then
            add(tnts, Tnt:new(10*8, 10*8, 10, 0))
            effects:explosion(10*8, 10*8)
            dcam.target = player
            self.gameStart = true
            player.velx = 0.1
            player.vely = 0.1
        end
    end
    dcam:update()
end

function IntroScene:draw()
    dcam:draw()
    cls(12)
    self.gui:draw()
    player:draw()
    drawEntities(tnts)
    map()
    effects:draw()
end