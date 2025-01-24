function _init()
    player = Player:new()
    dcam = Camera:new()
    transition = Transition:new(60, "test...")
    effects = Effects:new()
    
    tnts = {}
end

function _update60()

    player:update()
    dcam:update()
    effects:update()

    for tnt in all(tnts) do
        tnt:update()
    end

    if (player.y / 8 > 45) then
        player.y = -100
        player.vely = 0
        player.x = 64 * 8
        generate_word()
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
    effects:draw()   

    for tnt in all(tnts) do
        tnt:draw()
    end

    map()        
end