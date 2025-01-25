Upgrade = {}
local possibleUPgrade = {
    { value = "jump_f", description = "augmente la force de saut", baseValue = 10 },
    { value = "jump_m", description = "ajoute un saut supplémentaire", baseValue = 1 },
    { value = "speed", description = "boost de vitesse", baseValue = 0.3 },
    { value = "life", description = "augmente la santé", baseValue = 25 },
    { value = "life", description = "augmente la santé", baseValue = 25 },
    { value = "life", description = "augmente la santé", baseValue = 25 },
    { value = "tntPower", description = "augmente la puissance de la TNT", baseValue = 15 },
    { value = "tntRange", description = "augmente la portée de la TNT", baseValue = 100 },
    { value = "tntSpeed", description = "augmente la vitesse de la TNT", baseValue = -15 },
}

function Upgrade:new()
    local obj = {
        mineral = 4,
        upgradeA = nil,
        upgradeB = nil,
    }
    setmetatable(obj, self)
    self.__index = Upgrade
    return obj
end

function Upgrade:needUpgrade()
    return player.mineral >= self.mineral
end

function Upgrade:generate()
    self.upgradeA = possibleUPgrade[flr(rnd(#possibleUPgrade)) + 1]

    self.upgradeB = possibleUPgrade[flr(rnd(#possibleUPgrade)) + 1]
end

function Upgrade:display()
    local base = 20
    print("choose an upgrade", 0, base, 7)
    print("a : " .. self.upgradeA.description, 0, base + 8, 7)
    print("b : " .. self.upgradeB.description, 0, base + 16, 7)
end

function Upgrade:choose()
    if btnp(4) then
        self:upgradePlayer(self.upgradeA, 0)
    elseif btnp(5) then
        self:upgradePlayer(self.upgradeB, 0)
    end
end

function Upgrade:upgradePlayer(upgrade)
    player.mineral = player.mineral - self.mineral
    player[upgrade.value] = player[upgrade.value] + upgrade.baseValue
    self.mineral = flr(self.mineral * 1.5)
    self:generate()
end