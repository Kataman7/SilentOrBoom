EndScene = Scene:new()

function EndScene:new()
    local obj = Scene:new()
    obj.gui = EndText:new()
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function EndScene:update()
    self.gui:update()
end

function EndScene:draw()
    cls(12)
    self.gui:draw()
end