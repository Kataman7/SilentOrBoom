function _init()
    generate_cave()

    player = {
        h = 8,
        w = 8,
        velx = 0,
        vely = 0,
        x = 10,
        y = 0,
        speed = 0.2,
        jump_f = 5,
        frict = 0.85,
        jump_c = 0,
        jump_m = 3,
        sprite = 1,
        gravity = 0.4
    }
end

function _update60()
    player_control()
    player_update()
end

function _draw()
    cls()
    dcam()
    spr(player.sprite, player.x, player.y)
    map()
end