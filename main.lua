--++ DEBUGGING ++--
if arg[2] == "debug" then
	require("lldebugger").start()
end
--++ DEBUGGING ++--

--// Load //
function love.load()
	Object = require("lib.classic")
	require("classes.player")

	player = Player()
end

--// Draw //
function love.draw()
	player:draw()
end

--// Update //
function love.update(dt)
	player:update(dt)
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
