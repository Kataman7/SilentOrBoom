UpgradeMenu = Scene:new()

function UpgradeMenu:new()
    local obj = Scene:new()

    obj.upgrade = Upgrade:new()

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function UpgradeMenu:init()
    self.upgrade:generate()
    if self.upgrade:needUpgrade() then
        current_scene = scenes.upgradeMenu
    else 
        current_scene = scenes.gameLoop
    end
end

function UpgradeMenu:update()
    -- On applique l'upgrade si un bouton est pressé
    if btnp(4) then
        self.upgrade:upgradePlayer(self.upgrade.upgradeA)
    elseif btnp(5) then
        self.upgrade:upgradePlayer(self.upgrade.upgradeB)
    end
    -- Après application, on vérifie si le joueur peut encore upgrader
    if not self.upgrade:needUpgrade() then
        generate_world()
        changeScene(scenes.gameLoop)
    end
end

function UpgradeMenu:draw()
    camera(0,0) -- recentre la caméra pour l'UI
    cls(0) -- fond noir
    self.upgrade:draw()
end


