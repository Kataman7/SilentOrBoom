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
    print("update() must be implemented in subclas", 2)
end

function Gui:draw()
    print("draw() must be implemented in subclass", 2)
end