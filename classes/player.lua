Player = Object:extend()

--// Class //
function Player:new()
	self.x = 0
	self.y = 0
	self.angle = 0
	self.speed = 5 * 100
	self.health = 100.0
	self.radius = 25
	self.hand_radius = 10
	-- self.image = love.graphics.newImage("")
end

function Player:update(dt)
	--movement
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

	--look at
	local mouse_x, mouse_y = love.mouse.getPosition()
	self.angle = math.atan2(mouse_y - self.y, mouse_x - self.x)
end

function Player:draw()
	--body
	love.graphics.circle("line", self.x, self.y, self.radius)

	--hands
	local radius_sum = self.radius + self.hand_radius

	local lhand_angle = self.angle + math.rad(45)
	local lhand_x = self.x + math.cos(lhand_angle) * radius_sum
	local lhand_y = self.y + math.sin(lhand_angle) * radius_sum

	local rhand_angle = self.angle - math.rad(45)
	local rhand_x = self.x + math.cos(rhand_angle) * radius_sum
	local rhand_y = self.y + math.sin(rhand_angle) * radius_sum

	love.graphics.circle("line", lhand_x, lhand_y, self.hand_radius)
	love.graphics.circle("line", rhand_x, rhand_y, self.hand_radius)
end
