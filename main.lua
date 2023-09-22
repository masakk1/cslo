--++ DEBUGGING ++--
if arg[2] == "debug" then
	require("lldebugger").start()
end
--++ DEBUGGING ++--

--// Variables //
--collisions
local bump = require("lib.bump")

local world = bump.newWorld()

--objects
Object = require("lib.classic")
require("classes.player")
require("classes.wall")

local player = Player(world)
world:add(player, player.x, player.y, player.radius * 2, player.radius * 2)

local wallList = {}
local test_wall = Wall(300, 300, 100, 100)
world:add(test_wall, test_wall.x, test_wall.y, test_wall.width, test_wall.height)
table.insert(wallList, test_wall)

--// Load //
function love.load() end

--// Draw //
function love.draw()
	player:draw()

	for i, wall in ipairs(wallList) do
		wall:draw()
	end
end

--// Update //
function love.update(dt)
	player:update(dt, world)
end

--++ DEBUGGING ++--
local love_errorhandler = love.errhand

function love.errorhandler(msg)
	if lldebugger then
		error(msg, 2)
	else
		return love_errorhandler(msg)
	end
end
--++ DEBUGGING ++--
