function _init()
    player = Player:new()
    effects = Effects:new()
    dcam = Camera:new(player)
    tnts = {}

    scenes = {
        introScene = IntroScene:new(),
        gameLoop = GameLoop:new(),
        endScene = EndScene:new(),
        upgradeMenu = UpgradeMenu:new()
    }
    current_scene = scenes.introScene
    
end

function _update60()

    current_scene:update()

    --if not stat(57) then
        --music(12, -1, true)
    --end
end

function _draw()
    current_scene:draw()
end
