Entity = {}

function Entity:new(x, y, w, h, speed, gravity, frict, sprite)
    local obj = {
        x = x or 0,
        y = y or 0,
        w = w or 8,
        h = h or 8,
        velx = 0,
        vely = 0,
        speed = speed or 1,
        gravity = gravity or 0.2,
        frict = frict or 0.9,
        sprite = sprite,
        explosion_resistance=false,
        orientation = true
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Entity:check_collision(x, y)
    local top_left = map_position(x, y)
    local top_right = map_position(x + self.w - 1, y)
    local bottom_left = map_position(x, y + self.h - 1)
    local bottom_right = map_position(x + self.w - 1, y + self.h - 1)
    local flag = 0
    return fget(mget(top_left.x, top_left.y), flag)
            or fget(mget(top_right.x, top_right.y), flag)
            or fget(mget(bottom_left.x, bottom_left.y), flag)
            or fget(mget(bottom_right.x, bottom_right.y), flag)
end

function Entity:check_entity_collision(other)
    return self.x < other.x + other.w and
           self.x + self.w > other.x and
           self.y < other.y + other.h and
           self.y + self.h > other.y
end

function Entity:get_distance_to(other)
    return abs(self.x - other.x) + abs(self.y - other.y)
end

function Entity:update()
    self.vely = self.vely + self.gravity
    local new_y = self.y + self.vely

    if not self:check_collision(self.x, new_y) then
        self.y = new_y
    else
        self.vely = 0
    end

    self.velx = self.velx * self.frict
    local new_x = self.x + self.velx
    
    if (abs(self.velx) < 0.1) then
        self.velx = 0
    end

    if self.x ~= new_x then
        if not self:check_collision(new_x, self.y) then
            self.x = new_x
        else
            self.velx = 0
        end
    end
end

function Entity:draw()
    if self.sprite ~= 0 then

        if self.velx > 0 then
            self.orientation = false
        elseif self.velx < 0 then
            self.orientation = true
        end

        spr(self.sprite, self.x, self.y, 1, 1, self.orientation)
    end
end