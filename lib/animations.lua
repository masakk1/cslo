Anims = Object:extend()

function Anims:new(player)
	self.player = player
	self.time = 0
	self.past = {}
end

function Anims:doAnimation(animName, avoidLerp)
	if self[animName] then
		self[animName](self)
		if not avoidLerp then
			self:lerpPositions()
		end
	end
end
