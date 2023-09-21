Wall = Object:extend()

function Wall:new(x, y, width, height)
	self.isWall = true

	self.x = x
	self.y = y
	self.width = width
	self.height = height
end
function Wall:setPosition(x, y)
	self.x = x
	self.y = y
end
function Wall:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
