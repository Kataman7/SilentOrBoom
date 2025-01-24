Upgrade = {}
local possibleUPgrade = {
    { value = "jump_f", description = "increases jump strength", baseValue = 5 },
    { value = "jump_m", description = "adds an extra jump", baseValue = 1 },
    { value = "jump_c", description = "resets jump counter", baseValue = 0 },
    { value = "speed", description = "speed boost", baseValue = 0.2 },
    { value = "life", description = "increases health", baseValue = 20 },
    { value = "tntPower", description = "increases tnt power", baseValue = 10 },
    { value = "tntRange", description = "increases TNT range", baseValue = 100 },
    { value = "tntSpeed", description = "increases TNT speed", baseValue = 100 }
}

function Upgrade:new()
    local obj = {
        mineral = 10,
        upgradeA = nil,
        quantityA = 0,
        upgradeB = nil,
        quantityB = 0
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
    self.quantityA = flr(rnd(10)) + 1

    self.upgradeB = possibleUPgrade[flr(rnd(#possibleUPgrade)) + 1]
    self.quantityB = flr(rnd(10)) + 1
end

function Upgrade:display()
    local base = 20
    print("choose an upgrade", 0, base, 7)
    print("a : " .. self.upgradeA.description, 0, base + 8, 7)
    print("b : " .. self.upgradeB.description, 0, base + 16, 7)
end

function Upgrade:choose()
    if btnp(4) then
        self:upgradePlayer(self.upgradeA, self.quantityA)
    elseif btnp(5) then
        self:upgradePlayer(self.upgradeB, self.quantityB)
    end
end

function Upgrade:upgradePlayer(upgrade, quantity)
    player.mineral = player.mineral - self.mineral
    player[upgrade.value] = player[upgrade.value] + upgrade.baseValue * quantity
    self.mineral = self.mineral * 1.5
    self:generate()
end