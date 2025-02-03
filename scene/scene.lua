Scene = {}

function Scene:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Scene:init()
    print("init() must be implemented in subclass", 2)
end

function Scene:update()
    print("update() must be implemented in subclass", 2)
end

function Scene:draw()
    print("draw() must be implemented in subclass", 2)
end

function changeScene(scene)
    current_scene = scene
    current_scene:init()
end