-->8
function map_position(x, y)
    x = flr(x / 8)
    y = flr(y / 8)
    return { x = x, y = y }
end

function check_collision(x, y)
    local top_left = map_position(x, y)
    local top_right = map_position(x + player.w - 1, y)
    local bottom_left = map_position(x, y + player.h - 1)
    local bottom_right = map_position(x + player.w - 1, y + player.h - 1)
    local flag = 0
    return fget(mget(top_left.x, top_left.y, 1), flag)
            or fget(mget(top_right.x, top_right.y), flag)
            or fget(mget(bottom_left.x, bottom_left.y), flag)
            or fget(mget(bottom_right.x, bottom_right.y), flag)
end

function player_control()
    if btn(1) then
        player.velx += player.speed
    end
    if btn(0) then
        player.velx -= player.speed
    end
    if btn(⬆️) then
        if player.jump_c < player.jump_m then
            player.vely = -player.jump_f
            player.jump_c += 1
        end
    end
end

function player_update()
    player.vely += player.gravity
    new_y = player.y + player.vely

    if not check_collision(player.x, new_y) then
        player.y = new_y
    else
        player.vely = 0
        player.jump_c = 0
    end

    new_x = player.x + player.velx
    player.velx *= player.frict

    if not check_collision(new_x, player.y) then
        player.x = new_x
    else
        player.velx = 0
    end
end