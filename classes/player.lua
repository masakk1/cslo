Player = Object:extend()

--// Class //
function Player:new()
	self.isPlayer = true
	self.name = "Tom"

	self.cooldowns = {
		attack = { time = 0, max = 0.5 },
	}

	self.x = 0
	self.y = 0
	self.speed = 5 * 100
	self.angle = 0

	self.health = 100.0

	self.radius = 25
	self.hand_radius = 10
	-- self.image = love.graphics.newImage("")

	self.collisionFilter = function(item, other)
		if other.isWall then
			return "slide"
		end
	end
end

function Player:attack(mouse_x, mouse_y)
	print(self.name, "attacked")
end

function Player:update(dt, world)
	--update cooldowns
	for _, timer in pairs(self.cooldowns) do
		if timer.time > 0 then
			timer.time = timer.time - dt
		end
	end

	--move input
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
	--move
	local goal_x = self.x + move_x * self.speed * dt
	local goal_y = self.y + move_y * self.speed * dt
	local actualX, actualY, cols, len =
		world:move(self, goal_x - self.radius, goal_y - self.radius, self.collisionFilter)
	self.x, self.y = actualX + self.radius, actualY + self.radius

	--get angle
	local mouse_x, mouse_y = love.mouse.getPosition()
	self.angle = math.atan2(mouse_y - self.y, mouse_x - self.x)

	--action
	if love.mouse.isDown(1) and self.cooldowns.attack.time <= 0 then
		self:attack(mouse_x, mouse_y)
		self.cooldowns.attack.time = self.cooldowns.attack.max
	end
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
