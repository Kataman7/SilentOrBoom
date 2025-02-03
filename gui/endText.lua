EndText = Gui:new()

function EndText:new()
    local obj = Gui.new(self)

    obj.win = false

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function EndText:draw()
    if self.win then
        print("you win", 50, 40, 7)  -- Position Y réduite pour remonter le texte
    
        -- Conclusion de l'histoire
        print("with the speakers destroyed,", 0, 56, 7)  -- Position Y réduite
        print("silence finally returned.", 0, 64, 7)  -- Position Y réduite
        print("my cat purred softly,", 0, 72, 7)  -- Position Y réduite
        print("my plants grew peacefully,", 0, 80, 7)  -- Position Y réduite
        print("and my memories of metal", 0, 88, 7)  -- Position Y réduite
        print("festivals faded into a", 0, 96, 7)  -- Position Y réduite
        print("distant, nostalgic hum.", 0, 104, 7)  -- Position Y réduite
        print("peace was restored.", 0, 112, 12)  -- Position Y réduite, en bleu pour souligner l'importance
    else
        print("game over :'(", 50, 64, 7)
    end
end

function EndText:update()
    dcam:resets()
end