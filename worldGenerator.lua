_temp_map = {}
for i=0, 8191 do _temp_map[i] = 0 end

function map_position(x, y)
    return flr(x / 8), flr(y / 8)
end

function clear_tilemap()
    memset(0x2000, 0, 0x1000) -- Lignes 0-31
    memset(0x1000, 0, 0x1000) -- Lignes 32-63
end

function random_initialization(chance, livingTile, deadTile)
    for j = 0, 63 do
        for i = 0, 127 do
            if mget(i, j) == deadTile and rnd(1) < chance then
                mset(i, j, livingTile)
            end
        end
    end
end

function neighbor_count(x, y, livingTile)
    local count = 0
    if mget(x-1, y-1) == livingTile then count += 1 end
    if mget(x,   y-1) == livingTile then count += 1 end
    if mget(x+1, y-1) == livingTile then count += 1 end
    if mget(x-1, y)   == livingTile then count += 1 end
    if mget(x+1, y)   == livingTile then count += 1 end
    if mget(x-1, y+1) == livingTile then count += 1 end
    if mget(x,   y+1) == livingTile then count += 1 end
    if mget(x+1, y+1) == livingTile then count += 1 end
    return count
end

function next_cave_generation(livingTile, deadTile)
    for j = 0, 63 do
        local row = j * 128
        for i = 0, 127 do
            local count = 0
            if mget(i-1, j-1) == livingTile then count += 1 end
            if mget(i,   j-1) == livingTile then count += 1 end
            if mget(i+1, j-1) == livingTile then count += 1 end
            if mget(i-1, j)   == livingTile then count += 1 end
            if mget(i+1, j)   == livingTile then count += 1 end
            if mget(i-1, j+1) == livingTile then count += 1 end
            if mget(i,   j+1) == livingTile then count += 1 end
            if mget(i+1, j+1) == livingTile then count += 1 end
            
            if mget(i, j) == livingTile then
                _temp_map[row + i] = (count >= 4) and livingTile or deadTile
            else
                _temp_map[row + i] = (count >= 5) and livingTile or deadTile
            end
        end
    end
    for j = 0, 63 do
        local row = j * 128
        for i = 0, 127 do
            mset(i, j, _temp_map[row + i])
        end
    end
end

function next_conway_generation(livingTile, deadTile, min, max, birth, expend)
    for j = 0, 63 do
        local row = j * 128
        for i = 0, 127 do
            local count = 0
            if mget(i-1, j-1) == livingTile then count += 1 end
            if mget(i,   j-1) == livingTile then count += 1 end
            if mget(i+1, j-1) == livingTile then count += 1 end
            if mget(i-1, j)   == livingTile then count += 1 end
            if mget(i+1, j)   == livingTile then count += 1 end
            if mget(i-1, j+1) == livingTile then count += 1 end
            if mget(i,   j+1) == livingTile then count += 1 end
            if mget(i+1, j+1) == livingTile then count += 1 end

            local tile = mget(i, j)
            if tile == livingTile then
                _temp_map[row + i] = (count >= min and count <= max) and livingTile or deadTile
            elseif tile == deadTile then
                local is_born = expend and (count >= birth) or (count == birth)
                _temp_map[row + i] = is_born and livingTile or deadTile
            else
                _temp_map[row + i] = -1
            end
        end
    end
    for j = 0, 63 do
        local row = j * 128
        for i = 0, 127 do
            local val = _temp_map[row + i]
            if val != -1 then mset(i, j, val) end
        end
    end
end

function generate_land(grassTile, dirtTile, stoneTile)

    for i = 0, 127 do
        for j = 0, 31 do
            if (mget(i, j) == stoneTile) then
                mset(i, j, grassTile)
                mset(i, j+1, dirtTile)
                if (rnd(1) < 0.2) then
                    grass = {42, 58, 59, 60, 17, 17, 35, 35}
                    mset(i, j-1, rnd(grass))
                end
                break
            end
        end
    end
end

function generate_cave(livingTile, deadTile)
    random_initialization(0.53, livingTile, deadTile)
    for i = 1, 3 do
        next_cave_generation(livingTile, deadTile)
    end
end

function generate_mineral(mineralTile, chance, stoneTile)
    if (not stoneTile) then
        stoneTile = 51
    end
    random_initialization(chance, mineralTile, stoneTile)
    for i = 1, 2 do
       next_conway_generation(mineralTile, stoneTile, 2, 3, 3)
    end
end

function generate_dirt(dirtTile, chance, stoneTile, max, min, birth)
    local maxVal = max or 10
    local minVal = min or 1
    local birthVal = birth or 2

    random_initialization(chance, dirtTile, stoneTile)
    next_conway_generation(dirtTile, stoneTile, minVal, maxVal, birthVal, true)
end

function clear_grass()
    for i = 0, 127 do
        for j = 0, 63 do
            if (fget(mget(i, j)) == 3) then
                if (not fget(mget(i, j-1)) == 0) then
                    mset(i, j, 0)
                end
            end
        end
    end
end

function vine_generation(vineBlock)
    for i = 0, 127 do
        for j = 1, 63 do
            if (mget(i, j) == 0) then
                if (fget(mget(i, j-1)) == 1) then
                    if (rnd(1) < 0.2) then
                        local k = j
                        while (mget(i, k) == 0 and k < 64) do
                            mset(i, k, vineBlock)
                            k+=1
                        end
                    end
                end
            end
        end
    end
end

function deplacer_monstre(monstre,sens)
    local limit = 0
    while monstre:check_collision(monstre.x,monstre.y) and limit < 100 do
        if sens==1 then
            monstre.y=monstre.y+5
        else
            monstre.y=monstre.y-5
        end
        limit += 1
    end
end

function generate_monstres()
    local monstres = {}
    tnts = {}
    local max_y = 64 * 8

    for i = 1, player.stage * 2 + 4 do
        local x = flr(rnd(128 * 8))
        local y = flr(rnd(max_y))
        local zombie = Zombie:new(x, y)
        add(monstres, zombie)
        deplacer_monstre(zombie,0)
    end

    if (player.stage >= 2) then
        for i = 1, player.stage * 2 do
            local x = flr(rnd(128 * 8))
            local y = flr(rnd(max_y))
            local bat = Bat:new(x, y)
            add(monstres, bat)
            deplacer_monstre(bat,0)
        end
    end

    if (player.stage >= 4) then
        for i = 1, player.stage do
            local x = flr(rnd(128 * 8))
            local y = flr(rnd(max_y))
            local spider = Spider:new(x, y)
            add(monstres, spider)
            deplacer_monstre(spider,0)
        end
    end

    if (player.stage >= 6) then
        for i=1, player.stage*2 do
            local x = flr(rnd(128 * 8))
            local y = flr(rnd(max_y))
            local skull = Skull:new(x, y)
            add(monstres, skull)
            deplacer_monstre(skull,0)
        end
    end

    scenes.gameLoop.enemies = monstres
end

function generate_boss()
    local monstres = {}
    local boss1 = Boss:new(430, 222,0)
    add(monstres, boss1)
    local boss2 = Boss:new(452, 222,boss1)
    add(monstres, boss2)  
    scenes.gameLoop.enemies = monstres
end


function create_bunker()
    local width = 20  -- Largeur du bunker
    local height = 10  -- Hauteur du bunker
    local start_x = 50  -- Position X de départ
    local start_y = 20  -- Position Y de départ

    -- Ajuste la position Y si nécessaire
    if start_y + height > 64 then
        start_y = 64 - height
    end

    -- Génère le bunker avec trois couches de murs
    for layer = 1, 3 do
        local offset = layer - 1
        local tile

        -- Détermine le type de tile selon la couche
        if layer == 1 then
            tile = 18  -- Couche extérieure
        elseif layer == 3 then
            tile = 20  -- Couche intérieure
        else
            tile = 20  -- Couche intermédiaire
        end

        -- Mur supérieur (toit) en bloc 19 pour toutes les couches
        for i = start_x - offset, start_x + width + offset do
            mset(i, start_y - offset, 19)  -- Toit en bloc 19
        end

        -- Mur inférieur en blocs 18 ou 20
        for i = start_x - offset, start_x + width + offset do
            mset(i, start_y + height + offset, tile)
        end

        -- Murs gauche et droit avec motif alterné de 18 et 20
        for j = start_y - offset, start_y + height + offset do
            -- Mur gauche
            if (j + layer) % 2 == 0 then
                mset(start_x - offset, j, 18)
            else
                mset(start_x - offset, j, 20)
            end

            -- Mur droit
            if (j + layer) % 2 == 0 then
                mset(start_x + width + offset, j, 18)
            else
                mset(start_x + width + offset, j, 20)
            end
        end
    end

    -- Remplir l'intérieur avec du vide
    for i = start_x + 1, start_x + width - 1 do
        for j = start_y + 1, start_y + height - 1 do
            mset(i, j, 0)
        end
    end
end

function generate_biomeA()
    clear_tilemap()
    generate_cave(51, 0)
    generate_land(56, 52, 51)
    generate_dirt(52, 0.05, 51)
    generate_dirt(50, 0.05, 51)
    generate_dirt(49, 0.05, 51, 2, 5)
    generate_mineral(54, 0.1)
    generate_mineral(55, 0.1)
    generate_mineral(34, 0.1)
    vine_generation(53)
    clear_grass()
    generate_monstres()
end

function generate_biomeB()
    clear_tilemap()
    generate_cave(51, 0)
    generate_land(56, 52, 51)
    generate_dirt(52, 0.01, 51)
    generate_dirt(50, 0.05, 51)
    generate_dirt(49, 0.02, 51, 2, 5)
    generate_mineral(54, 0.1)
    generate_mineral(55, 0.1)
    generate_mineral(34, 0.1)
    generate_mineral(57, 0.2)
    vine_generation(53)
    clear_grass()
    generate_monstres()
end

function generate_biomeC()
    clear_tilemap()
    generate_cave(48, 0)
    vine_generation(24)

    if player.stage > 15 then
        create_bunker()
        generate_boss()
        dcam.levier = - 10000
    else
        generate_monstres()
    end

    generate_dirt(50, 0.06, 48)
    generate_dirt(20, 0.06, 48)
    generate_dirt(25, 0.08, 2, 5)
    generate_mineral(41, 0.2, 48)
end

function generate_world()
    if player.bonus_stage>0 then
        player.bonus_stage=player.bonus_stage-1
        generate_biomeB()
    elseif (player.stage < 10) then
        if rnd(1) < 0.2 then
            generate_biomeB()
        else
            generate_biomeA()
        end
    else 
        generate_biomeC()
    end
end
