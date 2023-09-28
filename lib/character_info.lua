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
	boxer = { -- testing class pretty much.
		name = "Boxer",
		description = "cuidao q t meto.",
		actions = {
			atk1 = {
				name = "punch",
				cooldown = 0.1,
				time = 0,
				damage = 10,
				boxes = { --x = angle, y = distance, s = range
					--hitbox_spread({ distance = 150, size = 100, spread = { -45, 45 }, res = 3 }), --main
					{ angle = 0, distance = 150, size = 100 },
				},
				combo = 3, -- nil == no combo
				animations = {
					sheet = "assets/Animations/boxing.png",
					frames = {
						{ "1-9",1 },
						{ "1-9",2 },
					},
				},
			},
			--atk2 = {},
		},
		idleAnim = {
			name = "idle",
			sheet = "assets/Animations/boxing.png",
			frames = {
				{ "1-9",1 },
			}
		}

		
	},
}
