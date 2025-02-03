IntroText = Gui:new()

function IntroText:new()
    local obj = Gui.new(self)
    
    obj.intro = 0

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function IntroText:draw()
    if self.intro == 0 then
        -- life was sweet. nothing could disturb my inner peace. except, perhaps... blasting music from the neighbors.
        print("life was sweet.", 0, 44, 7)  -- 64 - 20
        print("nothing could disturb", 0, 52, 7)  -- 72 - 20
        print("my inner peace.", 0, 60, 7)  -- 80 - 20
        print("except, perhaps...", 0, 68, 7)  -- 88 - 20
        print("blasting music from", 0, 76, 8)  -- 96 - 20
        print("the neighbors.", 0, 84, 8)  -- 104 - 20
    elseif self.intro == 1 then
        -- their music was so loud it woke up my cat, my plants, and even my old memories of metal festivals. that was the last straw.
        print("their music was so loud", 0, 44, 7)  -- 64 - 20
        print("it woke up my cat,", 0, 52, 7)  -- 72 - 20
        print("my plants, and even", 0, 60, 7)  -- 80 - 20
        print("my old memories of", 0, 68, 7)  -- 88 - 20
        print("metal festivals.", 0, 76, 7)  -- 96 - 20
        print("that was the last straw.", 0, 84, 7)  -- 104 - 20
    elseif self.intro == 2 then
        -- i brought out my tnt. not out of anger, but out of necessity. because silence is a right, and i was determined to reclaim it.
        print("i brought out my ", 0, 44, 7)  -- 64 - 20
        print("tnt", 66, 44, 8)  -- "TNT" en rouge
        print(".", 78, 44, 7)  -- 64 - 20
        print("not out of anger,", 0, 52, 7)  -- 72 - 20
        print("but out of necessity.", 0, 60, 7)  -- 80 - 20
        print("because ", 0, 68, 7)  -- 88 - 20
        print("silence", 31, 68, 12)  -- "silence" en bleu
        print(" is a", 58, 68, 7)  -- 88 - 20
        print("right, and i was", 0, 76, 7)  -- 96 - 20
        print("determined to reclaim it.", 0, 84, 7)  -- 104 - 20
    end
end

function IntroText:update()
    camera()

    if btnp(4) or btnp(5) then
        self.intro = self.intro + 1
    end
end