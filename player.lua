Player = Object:extend()
local DEBUGGING = false

--// Class //
function Player:new(data)
	if not data.world or not data.character then
		error("Player must have a world be given a character")
	end
	-- Attributes
	self.isPlayer = true
	self.isAlive = true

	-- Data
	self.world = data.world
	self.name = data.name or "Player"
	self.char = data.character

	-- Coordinates
	self.x = data.x or 0
	self.y = data.y or 0
	self.angle = 0
	self.w = 70
	self.h = 70
	self.hand_w = 10
	self.hand_h = 10

	-- Collisions
	self.collisionFilter = function(item, other)
		if other.isWall or other.isAlive then
			return "slide"
		end
	end

	-- Debugging
	self.debugging = DEBUGGING
	self.debugDraw = {}

	-- Animaton
	self.cooldowns = { atk1 = 0, atk2 = 0, global = 0 }
	self.playerActions = self.char.actions
	self.anims = Anims(self)

	self.state = "idle"
	self.action = self.playerActions.idle
end

--// Action Functions //
function Player:attack(action)
	local boxes = action.hitboxes
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
			if not hits[item] then
				hits[item] = true

				-- do damage
				if not item.isAlive then
					return
				end
				item:takeDamage(action.damage)
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
		self.dy = self.dy - self.char.speed * self.dt
	end
	if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
		self.dy = self.dy + self.char.speed * self.dt
	end
	if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
		self.dx = self.dx - self.char.speed * self.dt
	end
	if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
		self.dx = self.dx + self.char.speed * self.dt
	end
	--move
	local goal_x = self.x + self.dx
	local goal_y = self.y + self.dy
	local actual_x, actual_y = self.world:move(self, goal_x, goal_y, self.collisionFilter)
	self.x, self.y = actual_x, actual_y
end

function Player:actionCheck()
	local atk1 = self.playerActions.atk1
	local atk2 = self.playerActions.atk2

	if self.action.type == "hold" then
		-- if up, remove cooldown
		if not (love.mouse.isDown(1) or love.mouse.isDown(2)) then
			self.cooldowns.global = 0
		end
	end

	if self.cooldowns.global > 0 then
		return
	elseif love.mouse.isDown(1) and self.cooldowns.atk1 <= 0 then
		self:attack(atk1)
		self.state = "action"
		self.action = atk1
		self.cooldowns.atk1 = atk1.cooldown or atk1.duration
		self.cooldowns.global = atk1.duration or atk1.cooldown
	elseif love.mouse.isDown(2) and self.cooldowns.atk2 <= 0 then
		self:attack(atk2)
		self.state = "action"
		self.action = atk2
		self.cooldowns.atk2 = atk2.cooldown or atk1.duration
		self.cooldowns.global = atk2.duration or atk2.cooldown
	end
end

function Player:updateCooldowns()
	for k, cooldown in pairs(self.cooldowns) do
		if cooldown > 0 then
			self.cooldowns[k] = cooldown - self.dt
		end
	end
end

function Player:calculateState()
	if self.cooldowns.global <= 0 then
		self.state = "idle"
		self.action = self.playerActions.idle
	end
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

	-- Animations
	self.anims:update()
end

--// Draw //
function Player:draw()
	-- Draw player
	self.anims:draw()
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

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
