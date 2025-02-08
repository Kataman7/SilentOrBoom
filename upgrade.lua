Upgrade = {}
local possibleUPgrade = {
    { value = "jump_f", description = "increases jump strength", baseValue = 2 },
    { value = "jump_m", description = "adds an extra jump", baseValue = 1 },
    { value = "speed", description = "speed boost", baseValue = 0.3 },
    { value = "life", description = "increases health", baseValue = 25 },
    { value = "life", description = "increases health", baseValue = 25 },
    { value = "life", description = "increases health", baseValue = 25 },
    { value = "life", description = "increases health", baseValue = 25 },
    { value = "tntPower", description = "increases tnt power", baseValue = 5 },
    { value = "tntSpeed", description = "increases TNT speed", baseValue = -15 },
    { value = "mineral_mult", description = "Increases minerals collected per pickup", baseValue = 1 },
    { value = "stage", description = "Raises stage level", baseValue = 1 },
    { value = "stage", description = "Lowers stage level", baseValue = -1 }
}

function Upgrade:new()
    local obj = {
        mineral = 5,
        upgradeA = nil,
        upgradeB = nil,
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Upgrade:generate()
    self.upgradeA = possibleUPgrade[flr(rnd(#possibleUPgrade)) + 1]
    self.upgradeB = possibleUPgrade[flr(rnd(#possibleUPgrade)) + 1]
end

function Upgrade:update()
    if btnp(4) then
        self:upgradePlayer(self.upgradeA, 0)
    elseif btnp(5) then
        self:upgradePlayer(self.upgradeB, 0)
    end
end

function Upgrade:draw()
    local base = 20
    print("choose an upgrade", 0, base, 7)
    print("[o] : " .. self.upgradeA.description, 0, base + 8, 7)
    print("[x] : " .. self.upgradeB.description, 0, base + 16, 7)
end

function Upgrade:needUpgrade()
    return player.mineral >= self.mineral
end

function Upgrade:upgradePlayer(upgrade)
    player.mineral = player.mineral - self.mineral
    player[upgrade.value] = player[upgrade.value] + upgrade.baseValue
    self.mineral = flr(self.mineral * 1.5)
    self:generate()
end