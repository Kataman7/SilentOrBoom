TntAnim = Animation:new()

function TntAnim:new(lit)
    local obj = Animation:new(64, 71, 10)
    obj.lit = lit
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function TntAnim:update()
    self.anim_frame += 1
    if self.anim_frame >= self.anim_speed then
        self.anim_frame = 0
        if self.sprite == self.last_sprite then
            self.sprite = self.first_sprite
        else
            self.sprite += 1
        end
    end
end