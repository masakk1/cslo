Anims = Object:extend()

local SPRITE_SIZE = 512
local FPS30_FRAMETIME = 1 / 30

local function errorIfTrue(statement, ...)
	if statement then
		error(...)
	end
end

--// Constructor //
--# new(player: Player)
--* Makes a new animaton controller
function Anims:new(player)
	self.player = player
	self.anim8 = require("lib.anim8")
	self.playerActions = self.player.char.actions

	-- Actions
	self.animations = {} -- only the animation about the action
	self.spritesheet = love.graphics.newImage(self.player.char.spritesheet)

	for _, action in pairs(self.playerActions) do
		print(_, action)
		print("Loading action: ", action)
		self:loadAction(action)
	end
end

--// Loading Animations //

--# loadAnimation(name: string, action: {})
--* Loads given animation
function Anims:loadAnimation(name, frames, onLoopFunction)
	-- animation information
	local gridRes = { SPRITE_SIZE, SPRITE_SIZE }
	local grid = self.anim8.newGrid(gridRes[1], gridRes[2], self.spritesheet:getWidth(), self.spritesheet:getHeight())
	local frameTime = FPS30_FRAMETIME

	-- anim
	local anim = self.anim8.newAnimation(grid(unpack(frames)), frameTime, onLoopFunction)

	-- update Actions
	self.animations[name] = anim
end

--# loadAction(name: string, action: {})
--* Handles which and how to load an the animations of an action
--* action can be split into various (combo actions)
function Anims:loadAction(action)
	errorIfTrue(not action.type, "action", action, "doesn't have a type")
	errorIfTrue(not self.player.char.spritesheet, "There isn't a SpriteSheet for character", self.player.char.name)

	-- type combo = split into multiple actions
	if action.type == "combo" then
		for i = 1, #action do
			self:loadAnimation(action[i].name .. i, action[i].anim)

			if action[i].transitionAnim then
				self:loadAnimation(action[i].name .. i .. "transition", action[i].transitionAnim, function()
					self.transitioning = false
				end)
			end
		end
	else
		self:loadAnimation(action.name, action.anim)

		if action.transitionAnim then
			self:loadAnimation(action.name .. "transition", action.transitionAnim, function()
				self.transitioning = false
			end)
		end
	end
end

--// Set Action //
function Anims:setAction(action)
	self.action = action
	self.anim = self.animations[action.name]
	self.anim:gotoFrame(1)
	if action.transitionAnim then
		self.transitioning = true
		self.transitionAnim = self.animations[action.name .. "transition"]
		self.transitionAnim:gotoFrame(1)
	end
end

--// Update //
--TODO: make this combo-compatible
function Anims:update()
	if self.action == self.player.action then
		if self.transitioning then
			print("Transitioning!")
			self.transitionAnim:update(self.player.dt)
		else
			self.anim:update(self.player.dt)
		end
	else
		self:setAction(self.player.action)
	end
end

--// Draw //
function Anims:draw()
	local playingAnimation = self.anim
	if self.transitioning then
		playingAnimation = self.transitionAnim
	end
	playingAnimation:draw(
		self.spritesheet,
		self.player.x + self.player.w / 2,
		self.player.y + self.player.h / 2,
		self.player.angle + math.pi / 2,
		1,
		1,
		SPRITE_SIZE / 2,
		SPRITE_SIZE / 2
	)
end
