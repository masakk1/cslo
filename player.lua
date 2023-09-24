Player = Object:extend()
local DEBUGGING = true
local States = {
	Idle = true,
	Walk = true,
	Attack = true,
}

--// Class //
function Player:new(data)
	if not data.world then
		error("Player must have a world")
	end
	self.isPlayer = true
	self.isAlive = true
	self.name = data.name or "Player"
	self.world = data.world
	print(self.anims)

	self.state = States.Idle

	self.attacks = {
		punch = {
			cooldown = 0.5,
			time = 0,
			damage = 10,
			range = 80,
			distance = 110,
			anim = function() end,
		},
	}

	self.x = data.x or 0
	self.y = data.y or 0
	self.speed = data.speed or (5 * 100)
	self.angle = 0

	self.health = data.health or 100

	self.w = data.w or data.size or 60
	self.h = data.h or data.size or 60
	self.body_img = data.body_img or love.graphics.newImage("assets/Textures/Characters/red_character.png")
	self.hand_w = data.hand_w or data.size / 2.5 or 10
	self.hand_h = data.hand_h or data.size / 2.5 or 10
	self.hand_img = data.hand_img or love.graphics.newImage("assets/Textures/Characters/red_hand.png")

	self.collisionFilter = function(item, other)
		if other.isWall or other.isAlive then
			return "slide"
		end
	end

	self.debugDraw = {}
	self.past = {}
	self.anims = Anims(self)
end

--// Action Functions //
function Player:attack(attack)
	print(attack)
	local box_x = (self.x + self.w / 2 + math.cos(self.angle) * attack.distance) - attack.range / 2
	local box_y = (self.y + self.h / 2 + math.sin(self.angle) * attack.distance) - attack.range / 2

	table.insert(self.debugDraw, { x = box_x, y = box_y, w = attack.range, h = attack.range, t = 50 })
	local items, len = self.world:queryRect(box_x, box_y, attack.range, attack.range)

	for i = 1, len do
		local item = items[i]
		if item.isAlive then
			item:takeDamage(attack.damage)
			print("hit:", item.name, "| health:", item.health)
		end
	end
end

--// Entity Functions //
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

--// Update Functions //
function Player:getAngle()
	local mouse_x, mouse_y = love.mouse.getPosition()
	self.angle = math.atan2(mouse_y - self.y - self.h / 2, mouse_x - self.x - self.w / 2)
end

function Player:move(dt)
	self.dx, self.dy = 0, 0
	if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
		self.dy = self.dy - self.speed * dt
	end
	if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
		self.dy = self.dy + self.speed * dt
	end
	if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
		self.dx = self.dx - self.speed * dt
	end
	if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
		self.dx = self.dx + self.speed * dt
	end
	--move
	local goal_x = self.x + self.dx
	local goal_y = self.y + self.dy
	local actual_x, actual_y = self.world:move(self, goal_x, goal_y, self.collisionFilter)
	self.x, self.y = actual_x, actual_y
end

function Player:actionCheck()
	if love.mouse.isDown(1) and self.attacks.punch.time <= 0 then
		self:attack(self.attacks.punch)
		self.attacks.punch.time = self.attacks.punch.cooldown
	end
end

function Player:updateCooldowns(dt)
	for _, attack in pairs(self.attacks) do
		if attack.time > 0 then
			attack.time = attack.time - dt
		end
	end
end

--// Animations //
local function imgCenter(img)
	return img:getPixelWidth() / 2, img:getPixelHeight() / 2
end
function Player:animate()
	local center_x, center_y = self.x + self.w / 2, self.y + self.h / 2
	local halfHandW, halfHandH = self.hand_w / 2, self.hand_h / 2
	love.graphics.draw(self.body_img, center_x, center_y, 0, 1, 1, imgCenter(self.body_img))
	-- love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

	self.anims:calculatePositions()
	self.anims:lerpPositions()

	love.graphics.draw(
		self.hand_img,
		self.lhand_x + halfHandW,
		self.lhand_y + halfHandH,
		0,
		1,
		1,
		imgCenter(self.hand_img)
	)
	love.graphics.draw(
		self.hand_img,
		self.rhand_x + halfHandW,
		self.rhand_y + halfHandH,
		0,
		1,
		1,
		imgCenter(self.hand_img)
	)
	-- love.graphics.rectangle("line", self.lhand_x, self.lhand_y, self.hand_w, self.hand_h)
	-- love.graphics.rectangle("line", self.rhand_x, self.rhand_y, self.hand_w, self.hand_h)
end

--// Update //
local true_past = nil
function Player:update(dt)
	-- Update cooldowns
	self:updateCooldowns(dt)

	-- Input
	self:move(dt)
	self:actionCheck()
	self:getAngle()
end

--// Draw //
function Player:draw()
	-- Draw player
	self:animate()

	-- debug
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
