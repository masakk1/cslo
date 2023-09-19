--// Libraries //
require("lib.batteries"):export()
local vec2 = require("lib.batteries.vec2")

--// Variables //
local speed = 8 -- character speed
local player = {
    position = vec2(0, 0),
    health = 100.0
}


--// Draw //
local function draw_player()
    love.graphics.circle("fill", player.position.x, player.position.y, 30)
end
function love.draw()
    draw_player()
end

--// Update
function love.update()
    -- Input Handling
    local x, y = 0, 0
    if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        y = y - 1
    end
    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        y = y + 1
    end
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        x = x - 1
    end
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        x = x + 1
    end

    -- Move Player
    player.position:add_inplace(vec2(x * speed, y * speed))

end