Transition = {}

function Transition:new(frame, text)
    local obj = {
        frame = frame,
        text = text or "Loading..."
    }
    setmetatable(obj, { __index = self })
    return obj
end

function Transition:active()
    return self.frame > 0
end

function Transition:draw()
    if self:active() then
        rectfill(0, 0, 128, 128, 0)
        print(self.text, 64 - #self.text * 2, 64 - 4, 7)
        self.frame -= 1
    end
end
