Position = {}
Position.__index = Position

function Position:new(position)
    position = position or {}
    setmetatable(position, self)
    position.__index = self
    position.x = 0
    position.y = 0
    position.found = false

    return position
end

function Position:random_position(max_x, max_y)
    self.x = math.random(max_x - 1)
    self.y = math.random(max_y - 1)
    self.found = false
end

return {
    position = Position
}