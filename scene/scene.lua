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
    if #array == 0 then
        return
    end
    for i = #array, 1, -1 do
        local entity = array[i]
        entity:update()
        if entity.sprite == 0 then
            del(array, entity)
        end
    end
end

function drawEntities(array)
    for entity in all(array) do
        entity:draw()
    end
end