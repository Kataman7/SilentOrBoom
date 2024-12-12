-- Initialise une grille avec des valeurs aléatoires
function random_initialization(chance, livingTile, deadTile)
    for i = 1, 128 do
        for j = 1, 32 do
            if rnd(1) < chance then
                mset(i, j, livingTile) -- Tuile vivante
            else
                mset(i, j, deadTile) -- Tuile morte
            end
        end
    end
end

-- Compte les voisins ayant une certaine valeur
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

-- Applique une itération de l'automate
function apply_rule(livingTile, deadTile)
    local tempGrid = {}
    for i = 1, 128 do
        tempGrid[i] = {}
        for j = 1, 32 do
            local neighbors = neighbor_count(i, j, livingTile)
            local tile = mget(i, j)
            if tile == livingTile then
                -- Reste vivant si >= 4 voisins
                tempGrid[i][j] = (neighbors >= 4) and livingTile or deadTile
            else
                -- Devient vivant si >= 5 voisins
                tempGrid[i][j] = (neighbors >= 5) and livingTile or deadTile
            end
        end
    end
    -- Mise à jour de la grille
    for i = 1, 128 do
        for j = 1, 32 do
            mset(i, j, tempGrid[i][j])
        end
    end
end

-- Génération de la carte
function generate_cave()
    local livingTile = 51 -- Paramètre pour la tuile vivante
    local deadTile = 0 -- Paramètre pour la tuile morte
    random_initialization(0.48, livingTile, deadTile) -- 45% de chance de commencer vivant
    for i = 1, 5 do
        apply_rule(livingTile, deadTile) -- Appliquer la règle 5 fois
    end
end
