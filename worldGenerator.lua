function clear_tilemap()
    for i = 1, 128 do
        for j = 1, 32 do
            mset(i, j, 0)
        end
    end
end

function random_initialization(chance, livingTile, deadTile)
    for i = 1, 128 do
        for j = 1, 32 do
            if (mget(i, j) == deadTile) then
                if rnd(1) < chance then
                    mset(i, j, livingTile)
                end
            end
        end
    end
end

function neighbor_count(x, y, livingTile)
    local count = 0
    for i = -1, 1 do
        for j = -1, 1 do
            if not (i == 0 and j == 0) then
                if mget(x + i, y + j) == livingTile then
                    count = count + 1
                end
            end
        end
    end
    return count
end

function next_cave_generation(livingTile, deadTile)
    local tempGrid = {}
    for i = 1, 128 do
        tempGrid[i] = {}
        for j = 1, 32 do
            local neighbors = neighbor_count(i, j, livingTile)
            local tile = mget(i, j)
            if tile == livingTile then
                tempGrid[i][j] = (neighbors >= 4) and livingTile or deadTile
            else
                tempGrid[i][j] = (neighbors >= 5) and livingTile or deadTile
            end
        end
    end
    for i = 1, 128 do
        for j = 1, 32 do
            mset(i, j, tempGrid[i][j])
        end
    end
end

function next_conway_generation(livingTile, deadTile, min, max, birth, expend)
    local tempGrid = {}
    expend = expend or false
    for i = 1, 128 do
        tempGrid[i] = {}
        for j = 1, 32 do
            local neighbors = neighbor_count(i, j, livingTile)
            local tile = mget(i, j)
            if tile == livingTile then
                tempGrid[i][j] = (neighbors >= min and neighbors <= max) and livingTile or deadTile
            elseif tile == deadTile then
                if (expend) then
                    tempGrid[i][j] = (neighbors >= birth) and livingTile or deadTile
                else
                    tempGrid[i][j] = (neighbors == birth) and livingTile or deadTile
                end
            end
        end
    end
    for i = 1, 128 do
        for j = 1, 32 do
            if (tempGrid[i][j] == livingTile or tempGrid[i][j] == deadTile) then
                mset(i, j, tempGrid[i][j])
            end
        end
    end
end

function generate_land(grassTile, dirtTile, stoneTile)

    for i = 1, 128 do
        for j = 1, 10 do
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
    for i = 1, 5 do
        next_cave_generation(livingTile, deadTile)
    end
end

function generate_mineral(mineralTile, chance, stoneTile)
    if (not stoneTile) then
        stoneTile = 51
    end
    random_initialization(chance, mineralTile, stoneTile)
    for i = 1, 3 do
       next_conway_generation(mineralTile, stoneTile, 2, 3, 3)
    end
end

function generate_dirt(dirtTile, chance, stoneTile, max, min, birth)
    local maxVal = max or 10
    local minVal = min or 1
    local birthVal = birth or 2

    random_initialization(chance, dirtTile, stoneTile)
    for i = 1, 2 do
        next_conway_generation(dirtTile, stoneTile, minVal, maxVal, birthVal, true)
    end
end

function vine_generation(vineBlock)
    for i = 1, 128 do
        for j = 2, 32 do
            if (mget(i, j) == 0) then
                if (fget(mget(i, j-1)) == 1) then
                    if (rnd(1) < 0.2) then
                        local k = j
                        while (mget(i, k) == 0 and k < 32) do
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
    while monstre:check_collision(monstre.x,monstre.y) do
        if sens==1 then
            monstre.y=monstre.y+5
        else
            monstre.y=monstre.y-5
        end
    end
end

function generate_monstres()
    monstres = {}

    for i = 1, player.stage * 2 + 4 do
        local x = flr(rnd(128 * 8))
        local zombie = Zombie:new(x, 90)
        add(monstres, zombie)
        deplacer_monstre(zombie,0)
    end

    if (player.stage >= 2) then
        for i = 1, player.stage * 2 do
            local x = flr(rnd(128 * 8))
            local bat = Bat:new(x, 90)
            add(monstres, bat)
            deplacer_monstre(bat,0)
        end
    end

    if (player.stage >= 4) then
        for i = 1, player.stage do
            local x = flr(rnd(128 * 8))
            local spider = Spyder:new(x, 90)
            add(monstres, spider)
            deplacer_monstre(spider,0)
        end
    end

    if (player.stage >= 6) then
        for i=1, player.stage*2 do
            local x = flr(rnd(128 * 8))
            local skull = Skull:new(x, 90)
            add(monstres, skull)
            deplacer_monstre(skull,0)
        end
    end
end

function generate_boss()
    monstres = {}
    local boss1 = Boss:new(430, 122,0)
    add(monstres, boss1)
    local boss2 = Boss:new(452, 122,boss1)
    add(monstres, boss2)  
end


function create_bunker()
    local width = 20  -- Largeur du bunker
    local height = 10  -- Hauteur du bunker
    local start_x = 50  -- Position X de départ
    local start_y = 20  -- Position Y de départ

    -- Ajuste la position Y si nécessaire
    if start_y + height > 32 then
        start_y = 32 - height
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
end

function generate_biomeC()
    clear_tilemap()
    generate_cave(48, 0)
    vine_generation(24)

    if player.stage > 15 then
        create_bunker()
        generate_boss()
    end

    generate_dirt(50, 0.06, 48)
    generate_dirt(20, 0.06, 48)
    generate_dirt(25, 0.08, 2, 5)
    generate_mineral(41, 0.2, 48)
end

function generate_word()
    generate_biomeA()

    if (player.stage < 10) then
        if rnd(1) < 0.2 then
            generate_biomeB()
        else
            generate_biomeA()
        end
    else 
        generate_biomeC()
    end

    generate_monstres()
end
