Gui = {}

function Gui:new()
    if self == Gui then
        print("Gui is abstract", 2)
    end

    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Gui:update()
end

function Gui:draw()
end