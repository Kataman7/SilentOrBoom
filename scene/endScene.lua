EndScene = Scene:new()

function EndScene:new()
    local obj = Scene:new()
    obj.gui = EndText:new()
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function EndScene:init()
    -- Initialisation si nécessaire
end

function EndScene:update()
    self.gui:update()
end

function EndScene:draw()
    camera(0,0)
    cls(0)
    self.gui:draw()
end