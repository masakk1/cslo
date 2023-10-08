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
			angle = math.rad(angle_offset),
			distance = data.distance,
			size = data.size,
		})
	end
	return unpack(hitboxes)
end

--// Classes //
return {
	knight = {
		name = "Solid Knight",
		description = "It's a knight, defenitely not a hollow one",
		spritesheet = "assets/Animations/knight.png",

		-- Stats
		speed = 5 * 100,
		health = 100,

		-- Actions
		actions = {
			atk1 = {
				-- Meta
				name = "Swing",
				-- Combat
				type = "classic",
				damage = 10,
				hitboxes = {
					hitbox_spread({ distance = 150, size = 100, spread = { -45, 45 }, res = 3 }), --main
				},
				duration = 0.4,
				cooldown = nil, -- The cooldown is the same as the duration

				-- Animations
				anim = { "1-6", 1, "1-6", 2 },
				transitionAnim = nil, -- no transition anim
			},
			atk2 = {
				-- Meta
				name = "Shielding",
				-- Combat
				type = "hold",
				damage = 0,
				damageReduction = 0.5,
				hitboxes = {},
				duration = 5,
				cooldown = 10,

				-- Animations
				anim = { 6, 3 },
				transitionAnim = { "1-6", 3 }, -- no transition anim
			},
			idle = {
				name = "Idle",
				type = "idle",
				anim = { 1, 1 },
			},
		},
	},

	-- OLD, just in case of recovery... I guess?
	boxer = { -- testing class pretty much.
		name = "Boxer",
		description = "cuidao q t meto.",
		actions = {
			atk1 = {
				name = "punch",
				cooldown = 0.299,
				time = 0,
				damage = 10,
				boxes = { --x = angle, y = distance, s = range
					--hitbox_spread({ distance = 150, size = 100, spread = { -45, 45 }, res = 3 }), --main
					{ angle = 0, distance = 150, size = 100 },
				},
				combo = 2, -- nil == no combo
				animations = {
					sheet = "assets/Animations/boxing.png",
					frames = {
						{ "1-9", 1 },
						{ "1-9", 2 },
					},
				},
			},
			--atk2 = {},
		},
		idleAnim = {
			name = "idle",
			loops = true,
			sheet = "assets/Animations/boxing.png",
			frames = { "1-6", 3, "6-1", 3 },
			loop = true,
		},
	},
}
