Scene = {}

function Scene:new()
    local obj = {
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Scene:init()
end

function Scene:update()
end

function Scene:draw()
end