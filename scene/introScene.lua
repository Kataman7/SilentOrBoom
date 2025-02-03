IntroScene = Scene:new()

function IntroScene:new()
    local obj = Scene:new()

    obj.gui = IntroText:new()

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function IntroScene:update()
    self.gui:update()

    if self.gui.intro > 2 then
        changeScene(scenes.gameLoop)
    end
end

function IntroScene:draw()
    cls(12)
    self.gui:draw()
end