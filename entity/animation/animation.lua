Animation = {}

function Animation:new(first_sprite, last_sprite, anim_speed, frames)
    local obj = {
        sprite = first_sprite,
        first_sprite = first_sprite,
        last_sprite = last_sprite,
        anim_frame = 0,
        anim_speed = anim_speed,
        frames = frames,
        frame_idx = 1
    }

    if frames then obj.sprite = frames[1] end

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Animation:update()
    self.anim_frame += 1
    if self.anim_frame >= self.anim_speed then
        self.anim_frame = 0
        if self.frames then
            self.frame_idx = self.frame_idx % #self.frames + 1
            self.sprite = self.frames[self.frame_idx]
        else
            if self.sprite == self.last_sprite then
                self.sprite = self.first_sprite
            else
                self.sprite += 1
            end
        end
    end
end