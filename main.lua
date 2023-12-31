--++ DEBUGGING ++--
if arg[2] == "debug" then
	require("lldebugger").start()
end
--++ DEBUGGING ++--

--// Variables //
--collisions
local bump = require("lib.bump")
local world = bump.newWorld()

--require require require!
local char_info = require("lib.character_info")
Object = require("lib.classic")
require("lib.animations")

require("player")
require("classes.enemy")
require("classes.wall")

local entityList = {}
local objectList = {}
local player = Player({ character = char_info.knight, world = world, name = "EyEyEy", size = 70 })
table.insert(entityList, player)
world:add(player, player.x, player.y, player.w, player.h)

local test_wall = Wall(300, 300, 100, 100)
world:add(test_wall, test_wall.x, test_wall.y, test_wall.width, test_wall.height)
table.insert(objectList, test_wall)

local test_enemy = Enemy({ x = 600, y = 300, size = 100 })
world:add(test_enemy, test_enemy.x, test_enemy.y, test_enemy.w, test_enemy.h)
table.insert(entityList, test_enemy)

--// Load //
function love.load() end

--// Draw //
function love.draw()
	for _, entity in ipairs(entityList) do
		entity:draw()
	end
	for _, object in ipairs(objectList) do
		object:draw()
	end
end

--// Update //
function love.update(dt)
	for _, entity in ipairs(entityList) do
		entity:update(dt)
	end
end

--++ DEBUGGING ++--
---@diagnostic disable-next-line: undefined-field
local love_errorhandler = love.errhand

function love.errorhandler(msg)
	if lldebugger then
		error(msg, 2)
	else
		return love_errorhandler(msg)
	end
end
--++ DEBUGGING ++--
