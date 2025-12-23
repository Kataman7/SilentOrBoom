Scene = {}

function Scene:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Scene:init()
    print("Scene:init() must be implemented in subclass", 2)
end

function Scene:update()
    print("Scene:update() must be implemented in subclass", 2)
end

function Scene:draw()
    print("Scene:draw() must be implemented in subclass", 2)
end

function changeScene(scene)
    current_scene = scene
    current_scene:init()
end

function updateEntities(array)
    local n = #array
    if n == 0 then return end
    local j = 1
    for i = 1, n do
        local entity = array[i]
        entity:update()
        if entity.sprite ~= 0 then
            array[j] = entity
            j = j + 1
        end
    end
    for i = j, n do
        array[i] = nil
    end
end

function drawEntities(array)
    for entity in all(array) do
        entity:draw()
    end
end