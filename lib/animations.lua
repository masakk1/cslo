local tween = require("lib.flux")
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

--// Help Functions //
local function lerp(a, b, t)
	return (1 - t) * a + t * b
end

function Anims:lerpPositions()
	local plr = self.player
	if not self.past.lhand_x then
		self.past.lhand_x = plr.lhand_x
		self.past.lhand_y = plr.lhand_y
		self.past.rhand_x = plr.rhand_x
		self.past.rhand_y = plr.rhand_y
	end
	local lerp_t = plr.dt * 35
	plr.lhand_x = lerp(self.past.lhand_x, plr.lhand_x, lerp_t)
	plr.lhand_y = lerp(self.past.lhand_y, plr.lhand_y, lerp_t)
	self.past.lhand_x, self.past.lhand_y = plr.lhand_x, plr.lhand_y

	plr.rhand_x = lerp(self.past.rhand_x, plr.rhand_x, lerp_t)
	plr.rhand_y = lerp(self.past.rhand_y, plr.rhand_y, lerp_t)
	self.past.rhand_x, self.past.rhand_y = plr.rhand_x, plr.rhand_y
end

--// Animations //
function Anims:idle()
	self.time = self.time + self.player.dt
	local plr = self.player
	local distance_offset = math.sin(self.time * 2) * 1
	local angle_offset = math.sin(self.time * 2) * 0.05
	local distance = (plr.w / 2 + plr.hand_w / 2) + distance_offset
	local center_x, center_y = plr.x + plr.w / 2, plr.y + plr.h / 2

	local lhand_angle = plr.angle + math.rad(45) + angle_offset
	plr.lhand_x = center_x - plr.hand_w / 2 + math.cos(lhand_angle) * distance
	plr.lhand_y = center_y - plr.hand_h / 2 + math.sin(lhand_angle) * distance

	local rhand_angle = plr.angle - math.rad(45) - angle_offset
	plr.rhand_x = center_x - plr.hand_w / 2 + math.cos(rhand_angle) * distance
	plr.rhand_y = center_y - plr.hand_h / 2 + math.sin(rhand_angle) * distance
end
function Anims:walk()
	self:idle()
end
