function _init()
    player = Player:new()
    monstres = {}
    tirs = {}
    dcam = Camera:new()
    effects = Effects:new()
    tnts = {}
    upgrade = Upgrade:new()
    upgrade:generate()
    gui = GUI:new()
    music(0, -1, true)
end

function _update60()

    gui:update()
    
    
    if upgrade:needUpgrade() then
        upgrade:choose()
        return
    end

    if player.life <= 0 then
        return
    end

    player:update()

    if gui.intro < 3 then
        return
    end

    if player.boss_tuer>=2 then
        return
    end

    dcam:update()
    effects:update()

    for i = #tnts, 1, -1 do
        local tnt = tnts[i]
        tnt:update()
        if tnt.sprite == 0 then
            del(tnts, tnt)
        end
    end

    if (player.y / 8 > 45) then
        player.y = -100
        player.vely = 0
        player.x = 64 * 8
        generate_word()
        player.stage = player.stage + 1
    end

    for i = #monstres, 1, -1 do
        local monstre = monstres[i]
        monstre:update()
        if monstre.sprite == 0 then
            del(monstres, monstre)
        end
    end

    for i = #tirs, 1, -1 do
        local tir = tirs[i]
        tir:update()
        if tir.sprite == 0 then
            del(tirs, tir)
        end
    end

    if not stat(57) then
        music(12, -1, true)
    end
    
end

function _draw()

    if gui.intro < 3 then
        cls(0)
        gui:displayIntro()
        return
    end

    if player.boss_tuer>=2 then
        cls(0)
        GUI:displayWin()
        return
    end

    if player.life <= 0 then
        cls(0)
        gui:displayGameOver()
        return
    end

    if upgrade:needUpgrade() then
        Camera:resets()
        cls(0)
        upgrade:display()
        return
    end

    dcam:draw()
    cls(12)
    player:draw()
    for monstre in all(monstres) do
        monstre:draw()
    end
    for tir in all(tirs) do
        tir:draw()
    end
    map()
    effects:draw()

    for tnt in all(tnts) do
        tnt:draw()
    end

    gui:draw()
end
