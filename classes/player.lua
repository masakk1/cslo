Player = Object:extend()
local DEBUGGING = true

--// Class //
function Player:new(data)
	if not data.world then
		error("Player must have a world")
	end
	self.isPlayer = true
	self.isAlive = true
	self.name = data.name or "Player"
	self.world = data.world
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

	self.x = data.x or 0
	self.y = data.y or 0
	self.speed = data.speed or (5 * 100)
	self.angle = 0

	self.health = data.health or 100

	self.w = data.w or data.size or 30
	self.h = data.h or data.size or 30
	self.hand_w = data.hand_w or data.size / 2.5 or 10
	self.hand_h = data.hand_h or data.size / 2.5 or 10

	self.collisionFilter = function(item, other)
		if other.isWall or other.isAlive then
			return "slide"
		end
	end
end

function Player:attack()
	local punch = self.attacks.punch
	local box_x = (self.x + self.w / 2 + math.cos(self.angle) * punch.distance) - punch.range / 2
	local box_y = (self.y + self.h / 2 + math.sin(self.angle) * punch.distance) - punch.range / 2

	table.insert(self.debugDraw, { x = box_x, y = box_y, w = punch.range, h = punch.range, t = 50 })
	local items, len = self.world:queryRect(box_x, box_y, punch.range, punch.range)

	for i = 1, len do
		local item = items[i]
		if item.isAlive then
			item:takeDamage(punch.damage)
			print("hit:", item.name, "| health:", item.health)
		end
	end
end

function Player:takeDamage(damage)
	self.health = self.health - damage
	if self.health <= 0 then
		self:destroy()
	end
end
function Player:destroy()
	print(self.name, "is dead")
	self.isAlive = false
	--TODO: death animation and respawn
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
	local actual_x, actual_y = self.world:move(self, goal_x, goal_y, self.collisionFilter)
	self.x, self.y = actual_x, actual_y

	--get angle
	local mouse_x, mouse_y = love.mouse.getPosition()
	self.angle = math.atan2(mouse_y - self.y - self.h / 2, mouse_x - self.x - self.w / 2)

	--action
	if love.mouse.isDown(1) and self.attacks.punch.time <= 0 then
		self:attack()
		self.attacks.punch.time = self.attacks.punch.cooldown
	end
end

function Player:draw()
	--body
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

	--hands
	local radius_sum = self.w / 2 + self.hand_w / 2
	local center_x, center_y = self.x + self.w / 2, self.y + self.h / 2

	local lhand_angle = self.angle + math.rad(45)
	local lhand_x = center_x - self.hand_w / 2 + math.cos(lhand_angle) * radius_sum
	local lhand_y = center_y - self.hand_w / 2 + math.sin(lhand_angle) * radius_sum

	local rhand_angle = self.angle - math.rad(45)
	local rhand_x = center_x - self.hand_w / 2 + math.cos(rhand_angle) * radius_sum
	local rhand_y = center_y - self.hand_w / 2 + math.sin(rhand_angle) * radius_sum

	love.graphics.rectangle("line", lhand_x, lhand_y, self.hand_w, self.hand_h)
	love.graphics.rectangle("line", rhand_x, rhand_y, self.hand_w, self.hand_h)

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
