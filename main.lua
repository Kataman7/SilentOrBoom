function _init()
    player = Player:new()
    monstres = {}
    dcam = Camera:new()
    transition = Transition:new(60, "test...")
    effects = Effects:new()
    tnts = {}
    upgrade = Upgrade:new()
    upgrade:generate()
    gui = GUI:new()
    music(0, -1, true)
end

function _update60()

    if upgrade:needUpgrade() then
        upgrade:choose()
        return
    end

    player:update()
    dcam:update()
    effects:update()
    gui:update()

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

    if not stat(57) then
        music(12, -1, true)
    end
    
end

function _draw()

    if upgrade:needUpgrade() then
        Camera:resets()
        cls(0)
        print("test", 64, 64, 7)
        upgrade:display()
        return
    end

    if transition:active() then
        transition:draw()
        return
    end

    dcam:draw()
    cls(12)
    player:draw()
    for monstre in all(monstres) do
        monstre:draw()
    end
    map()
    effects:draw()

    for tnt in all(tnts) do
        tnt:draw()
    end

    gui:draw()
end
