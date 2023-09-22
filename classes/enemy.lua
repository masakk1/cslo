Enemy = Object:extend()

function Enemy:new(data)
	self.name = data.name or "Enemy"
	self.isEnemy = true
	self.isAlive = true

	self.x = data.x or 300
	self.y = data.y or 300
	self.w = data.w or data.size or 50
	self.h = data.h or data.size or 50

	self.health = data.health or 100
end

function Enemy:draw()
	-- love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	love.graphics.circle("line", self.x + self.w / 2, self.y + self.h / 2, self.w / 2)
end
function Enemy:takeDamage(damage)
	self.health = self.health - damage
	if self.health <= 0 then
		self:destroy()
	end
end
function Enemy:destroy()
	print(self.name, "is dead")
	self.isAlive = false
	--TODO
end
function Enemy:update() end
