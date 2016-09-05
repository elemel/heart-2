local World = {}
World.__index = World

function World.new(data)
	local world = setmetatable({}, World)
	world.name = "world"

	world.gravityX = data.gravityX or 0
	world.gravityY = data.gravityY or -10
	world.allowSleeping = data.allowSleeping or true

	if data.entity then
		data.entity:addComponent(self)
	end

	return world
end

function World:destroy()
	self.entity:removeComponent(self)
end

function World:start()
	self.world = love.physics.newWorld(
		self.gravityX, self.gravityY, self.allowSleeping)
end

function World:stop()
	self.world:destroy()
	self.world = nil
end

function World:update(dt)
	self.world.update(dt)
end

return World
