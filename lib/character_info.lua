--// Functions //
--# Creates hitboxes on a radius
local function hitbox_spread(data)
	local hitboxes = {}
	if not data["spread"] then
		data.spread = { -45, 45 }
	end
	local spacing = (data.spread[2] - data.spread[1]) / (data.res - 1)

	for i = 0, data.res - 1 do
		local angle_offset = data.spread[1] + i * spacing
		table.insert(hitboxes, {
			angle = angle_offset,
			distance = data.distance,
			size = data.size,
		})
	end
	return table.unpack(hitboxes)
end

--// Classes //
return {
	knight = {
		name = "Jerry",
		description = "A simple knight. Not a hollow one!",
		actions = {
			[1] = {
				name = "swing",
				cooldown = 1,
				time = 0,
				damage = 10,
				hitboxes = { --x = angle, y = distance(+player.h/2), s = range
					hitbox_spread({ distance = 100, size = 75, spread = { -45, 45 }, res = 3 }), --main
					hitbox_spread({ distance = 170, size = 75, spread = { -45, 45 }, res = 5 }), --longer range
				},
				anim = "BroadSwing",
			},
			[2] = {},
		},
	},
}
