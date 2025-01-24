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

function generate_land()
    local grassTile = 56
    local dirtTile = 52
    local stoneTile = 51

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

function generate_cave()
    local livingTile = 51
    local deadTile = 0
    random_initialization(0.53, livingTile, deadTile)
    for i = 1, 5 do
        next_cave_generation(livingTile, deadTile)
    end
end

function generate_mineral(mineralTile, chance)
    random_initialization(chance, mineralTile, 51)
    for i = 1, 3 do
       next_conway_generation(mineralTile, 51, 2, 3, 3)
    end
end

function generate_dirt(dirtTile, chance, max, min, birth)
    local stoneTile = 51
    local maxVal = max or 10
    local minVal = min or 1
    local birthVal = birth or 2

    random_initialization(chance, dirtTile, stoneTile)
    for i = 1, 2 do
        next_conway_generation(dirtTile, stoneTile, minVal, maxVal, birthVal, true)
    end
end

function vine_generation()
    for i = 1, 128 do
        for j = 2, 32 do
            if (mget(i, j) == 0) then
                if (fget(mget(i, j-1)) == 1) then
                    if (rnd(1) < 0.2) then
                        local k = j
                        while (mget(i, k) == 0 and k < 32) do
                            mset(i, k, 53)
                            k+=1
                        end
                    end
                end
            end
        end
    end
end

function generate_monstres()
    for i = 1, 20 do
        local x = flr(rnd(1280))
        local zombie = Zombie:new(x, 90)
        add(monstres, zombie)
    end
    for i = 1, 20 do
        local x = flr(rnd(1280))
        local spyder = Spyder:new(x, 90)
        add(monstres, spyder)
    end
    for i = 1, 20 do
        local x = flr(rnd(1280))
        local bat = Bat:new(x, 90)
        add(monstres, bat)
    end
end

function generate_word()
    clear_tilemap()
    generate_cave()
    generate_land()
    generate_dirt(52, 0.05)
    generate_dirt(50, 0.05)
    generate_dirt(49, 0.05, 2, 5)
    generate_mineral(54, 0.1)
    generate_mineral(55, 0.1)
    generate_mineral(34, 0.1)
    vine_generation(52)
    generate_monstres()
end
