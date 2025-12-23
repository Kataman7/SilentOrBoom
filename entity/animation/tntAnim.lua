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
        if self.sprite == 72 then
            -- Si on était sur le blanc, on revient à la séquence normale
            self.sprite = self.last_normal_sprite or self.first_sprite
        else
            -- Une fois sur deux, on passe au blanc
            self.last_normal_sprite = self.sprite
            self.sprite = 72
        end
    end
end