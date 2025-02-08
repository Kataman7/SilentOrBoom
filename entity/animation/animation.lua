Animation = {}

function Animation:new(first_sprite, last_sprite, anim_speed)
    local obj = {
        sprite = first_sprite,
        first_sprite = first_sprite,
        last_sprite = last_sprite,
        anim_frame = 0,
        anim_speed = anim_speed,
    }

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Animation:update()
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