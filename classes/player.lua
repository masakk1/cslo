Player = Object:extend()
local DEBUGGING = true

--// Class //
function Player:new(world)
	self.isPlayer = true
	self.name = "Tom"
	self.world = world
	self.debugDraw = {}

	self.attacks = {
		punch = {
			cooldown = 0.5,
			time = 0,
			damage = 10,
			range = 80,
			distance = 110,
		},
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

function Player:attack()
	local punch = self.attacks.punch
	print(self.name, "attacked")
	local box_x = (self.x + math.cos(self.angle) * punch.distance) - punch.range / 2
	local box_y = (self.y + math.sin(self.angle) * punch.distance) - punch.range / 2

	print(self.world:queryRect(box_x, box_y, punch.range, punch.range))
	table.insert(self.debugDraw, { x = box_x, y = box_y, w = punch.range, h = punch.range, t = 50 })
end

function Player:update(dt)
	--update cooldowns
	for _, attack in pairs(self.attacks) do
		if attack.time > 0 then
			attack.time = attack.time - dt
		end
	end

	--move input
	local dx, dy = 0, 0
	if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
		dy = dy - self.speed * dt
	end
	if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
		dy = dy + self.speed * dt
	end
	if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
		dx = dx - self.speed * dt
	end
	if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
		dx = dx + self.speed * dt
	end
	--move
	local goal_x = self.x + dx
	local goal_y = self.y + dy
	local actual_x, actual_y = self.world:move(self, goal_x - self.radius, goal_y - self.radius, self.collisionFilter)
	self.x, self.y = actual_x + self.radius, actual_y + self.radius

	--get angle
	local mouse_x, mouse_y = love.mouse.getPosition()
	self.angle = math.atan2(mouse_y - self.y, mouse_x - self.x)

	--action
	if love.mouse.isDown(1) and self.attacks.punch.time <= 0 then
		self:attack()
		self.attacks.punch.time = self.attacks.punch.cooldown
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

	--debug
	if not DEBUGGING then
		return
	end
	for i = 1, #self.debugDraw do
		local r = self.debugDraw[i]
		if r then
			love.graphics.rectangle("line", r.x, r.y, r.w, r.h)
			if r.t <= 0 then
				table.remove(self.debugDraw, i)
			else
				self.debugDraw[i].t = self.debugDraw[i].t - 1
			end
		end
	end
end
