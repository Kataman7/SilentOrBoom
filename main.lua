function _init()
    player = Player:new()
    monstres = {}
    dcam = Camera:new()
    transition = Transition:new(60, "test...")
    effects = Effects:new()
    generate_monstres()
    tnts = {}
end

function _update60()

    player:update()
    dcam:update()
    effects:update()
    if player.life<=0 then
        transition = Transition:new(60,"Game Over")
        player.y = -100
        player.vely = 0
        player.x = 64 * 8
        player.life = 20
        generate_word()
    end
    
    for tnt in all(tnts) do
        tnt:update()
    end

    if (player.y / 8 > 45) then
        player.y = -100
        player.vely = 0
        player.x = 64 * 8
        player.life = player.life + 5
        generate_word()
    end
    
    for monstre in all(monstres) do
        monstre:update()
    end

end

function _draw()
    if (transition:active()) then
        transition:draw()
        return
    end

    dcam:draw()
    cls(12)
    player:draw()
    for monstre in all(monstres) do
        monstre:draw()
    end
    effects:draw()
    map()

    for tnt in all(tnts) do
        tnt:draw()
    end
end