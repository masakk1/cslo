Anims = Object:extend()

function Anims:new(player)
	self.player = player
	self.time = 0
	self.anim8 = require("lib.anim8")

	self.playingAction = nil
	-- load all animations
	self.actions = {}
	--MOVEMENT

	--ACTIONS
	for k, action in pairs(self.player.char.actions) do
		print(k, action.name)
		self.actions[action.name] = {}
		local sheet = love.graphics.newImage(action.animations.sheet)
		local gridRes = { 512, 512 }
		if action.grid then
			gridRes = action.grid
		end

		local grid = self.anim8.newGrid(gridRes[1], gridRes[2], sheet:getWidth(), sheet:getHeight())
		self.actions[action.name].sheet = sheet
		self.actions[action.name].grid = grid

		if not action.combo or action.combo <= 0 then
			--case1: 1 sheet, 1 animation / no combo
			self.actions[action.name].anim = self.anim8.newAnimation(
				grid(unpack(action.animations.frames)),
				action.animations.frameTime or 0.033 -- 0.4166 = 24fps| 0.0333 = 30fps | 0.0166 == 60
			)
		else
			self.actions[action.name].comboAmount = action.combo
			self.actions[action.name].comboCount = 1
			self.actions[action.name].anim = {}
			for k, animFrames in pairs(action.animations.frames) do
				local frames = grid(unpack(animFrames))
				table.insert(self.actions[action.name].anim, {
					frames = frames,
					frameTime = action.animations.frameTime or 0.033, -- 0.4166 = 24fps| 0.0333 = 30fps | 0.0166 == 60
				})
			end
		end
	end
end

function Anims:draw()
	self.playingAction:draw()
end

function Anims:setAction()
	if self.player.state == "action" then
		self.playingAction = self.actions[self.player.action.name].animations
	else
		self.playingAction = self.player.char.idleAnim
	end
end
function Anims:updateCombo()
	if self.playingAction.comboCount >= self.playingAction.comboAmount then
		self.playingAction.comboCount = 1
	else
		self.playingAction.comboAmount = self.playingAction.comboAmount + 1
	end
end

function Anims:update()
	local action = self.playingAction

	print(action)
	if not action then
		self:setAction()
		return
	end
	print(action)

	-- update action
	if action.name == self.player.state or action.name == self.player.action.name then
		action.anim:update(self.player.dt)
	else
		-- load an action

	end
end



