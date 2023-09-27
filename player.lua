Player = Object:extend()
local DEBUGGING = true

--// Class //
function Player:new(data)
	if not data.world or not data.character then
		error("Player must have a world be given a character")
	end
	self.isPlayer = true
	self.isAlive = true
	self.world = data.world
	self.name = data.name or "Player"

	self.char = data.character

	self.state = "idle"
	self.actionsCooldown = 0

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
	local boxes = attack.boxes
	local hits = {}

	local items, len = {}, 0
	-- check collisions
	for _, box in pairs(boxes) do
		if box.angle then -- angle-based
			local cos = math.cos(self.angle + box.angle)
			local sin = math.sin(self.angle + box.angle)
			local bw, bh = box.size, box.size
			local bx = (self.x + self.w / 2 - box.size / 2) + cos * box.distance
			local by = (self.y + self.h / 2 - box.size / 2) + sin * box.distance

			table.insert(self.debugDraw, { x = bx, y = by, w = bw, h = bh, t = 50 })
			items, len = self.world:queryRect(bx, by, bw, bh)
		else -- position based (UNTESTED)
			table.insert(self.debugDraw, { x = box.x, y = box.y, w = box.w, h = box.h, t = 50 })
			items, len = self.world:queryRect(box.x, box.y, box.w, box.h)
		end

		-- validate hits
		for i = 1, len do
			local item = items[i]
			table.insert(hits, item)

			-- do damage
			if item.isAlive then
				item:takeDamage(attack.damage)
				print("hit:", item.name, "| health:", item.health) -- DEBUGGING - REMOVE LATER!
			end
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

function Player:move()
	self.dx, self.dy = 0, 0
	if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
		self.dy = self.dy - self.speed * self.dt
	end
	if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
		self.dy = self.dy + self.speed * self.dt
	end
	if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
		self.dx = self.dx - self.speed * self.dt
	end
	if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
		self.dx = self.dx + self.speed * self.dt
	end
	--move
	local goal_x = self.x + self.dx
	local goal_y = self.y + self.dy
	local actual_x, actual_y = self.world:move(self, goal_x, goal_y, self.collisionFilter)
	self.x, self.y = actual_x, actual_y
end

function Player:actionCheck()
	local atk1 = self.char.actions.atk1
	if love.mouse.isDown(1) and atk1.time <= 0 and self.actionsCooldown <= 0 then
		self:attack(atk1)
		self.state = "action"
		self.action = atk1
		atk1.time = atk1.cooldown
		self.actionsCooldown = atk1.actionDuration or 0.5 -- REMOVE THIS LATER ON!
	end
end

function Player:updateCooldowns()
	for _, action in pairs(self.char.actions) do
		if not action.time then
			action.time = 0
		end
		if action.time > 0 then
			action.time = action.time - self.dt
		end
	end
	self.actionsCooldown = self.actionsCooldown - self.dt
end

function Player:calculateState()
	if self.actionsCooldown <= 0 then
		if self.dx ~= 0 or self.dy ~= 0 then
			self.state = "walk"
		else
			self.state = "idle"
		end
	end
end

--// Animations //
local function imgCenter(img)
	return img:getPixelWidth() / 2, img:getPixelHeight() / 2
end
function Player:animate()
	local center_x, center_y = self.x + self.w / 2, self.y + self.h / 2
	love.graphics.draw(self.body_img, center_x, center_y, 0, 1, 1, imgCenter(self.body_img))
	-- love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

	if self.state == "action" then
		self.anims:doAnimation(self.action.anim)
	else
		self.anims:clearAnimation()
		self.anims:doAnimation(self.state)
	end

	local halfHandW, halfHandH = self.hand_w / 2, self.hand_h / 2
	local lImg_x, lImg_y = self.lhand_x + halfHandW, self.lhand_y + halfHandH
	local rImg_x, rImg_y = self.rhand_x + halfHandW, self.rhand_y + halfHandH
	love.graphics.draw(self.hand_img, lImg_x, lImg_y, 0, 1, 1, imgCenter(self.hand_img))
	love.graphics.draw(self.hand_img, rImg_x, rImg_y, 0, 1, 1, imgCenter(self.hand_img))
	-- love.graphics.rectangle("line", self.lhand_x, self.lhand_y, self.hand_w, self.hand_h)
	-- love.graphics.rectangle("line", self.rhand_x, self.rhand_y, self.hand_w, self.hand_h)
end

--// Update //
function Player:update(dt)
	self.dt = dt
	-- Update cooldowns
	self:updateCooldowns()

	-- Input
	self:move()
	self:actionCheck()
	self:getAngle()

	self:calculateState()
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
