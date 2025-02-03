UpgradeMenu = Scene:new()

function UpgradeMenu:new()
    local obj = Scene:new()

    obj.upgrade = Upgrade:new()

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function UpgradeMenu:init()

    if self.upgrade:needUpgrade() then
        current_scene = scenes.upgradeMenu
    else 
        current_scene = scenes.gameLoop
    end

end

function UpgradeMenu:update()
    self.upgrade:update()
end

function UpgradeMenu:draw()
    self.upgrade:draw() 
end


