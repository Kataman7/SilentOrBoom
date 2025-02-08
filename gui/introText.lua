IntroText = Gui:new()

function IntroText:new()
    local obj = Gui:new()

    obj.intro = 0

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function IntroText:draw()
    if not scenes.introScene.gameStart then
        color(7)  -- Blanc
        print("Silence ... Or ", 8.5*8, 6*8)

        color(8)  -- Rouge
        print("BOOM !", 16.5*8, 6*8)

        color(7)  -- Blanc
        print("Press X", 14*8, 12*8)
    else
        color(7)
        print("can we turn down the music?", 8*8, 8*8)
        print("it's unbearable!", 8*8, 9*8)

        print("jump into", 21*8, 20*8)
        print("the void", 21*8, 21*8)
        print("to see", 21*8, 22*8)
        print("the neighbors", 21*8, 23*8)
    end    
end