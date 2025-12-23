UpgradeMenu = Scene:new()

function UpgradeMenu:new()
    local obj = Scene:new()

    obj.upgrade = Upgrade:new()
    obj.state = "choosing"

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function UpgradeMenu:init()
    self.state = "choosing"
    self.upgrade:generate()
    if self.upgrade:needUpgrade() then
        current_scene = scenes.upgradeMenu
    else 
        current_scene = scenes.gameLoop
    end
end

function UpgradeMenu:update()
    if self.state == "choosing" then
        -- On applique l'upgrade si un bouton est pressé
        if btnp(4) then
            self.upgrade:upgradePlayer(self.upgrade.upgradeA)
            if self.upgrade:needUpgrade() then
                self.upgrade:generate()
            else
                self.state = "generating"
            end
        elseif btnp(5) then
            self.upgrade:upgradePlayer(self.upgrade.upgradeB)
            if self.upgrade:needUpgrade() then
                self.upgrade:generate()
            else
                self.state = "generating"
            end
        end
    elseif self.state == "generating" then
        generate_world()
        changeScene(scenes.gameLoop)
    end
end

function UpgradeMenu:draw()
    camera(0,0) -- recentre la caméra pour l'UI
    cls(0) -- fond noir
    if self.state == "choosing" then
        self.upgrade:draw()
    elseif self.state == "generating" then
        print("generating world...", 35, 60, 7)
    end
end


