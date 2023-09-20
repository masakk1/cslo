Player = Object:extend()

function Player:new()
    self.x = 0
    self.y = 0
    self.speed = 5 * 100
    self.health = 100.0
    -- self.image = love.graphics.newImage("")
end

function Player:move(x, y, dt)
    self.x = self.x + self.speed * dt
    self.y = self.y + self.speed * dt
end

function Player:update(dt)
    local move_x, move_y = 0, 0
    if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        move_y = move_y - 1
    end
    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        move_y = move_y + 1
    end
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        move_x = move_x - 1
    end
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        move_x = move_x + 1
    end
    self.x = self.x + move_x * self.speed * dt
    self.y = self.y + move_y * self.speed * dt
end

function Player:draw()
    -- love.graphics.draw(self.image)
    love.graphics.circle("line", self.x, self.y, 20)
end