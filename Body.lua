local Body = {}
Body.__index = Body

function Body.new(data)
	local body = setmetatable({}, Body)
	body.name = "body"

	if data.entity then
		data.entity:addComponent(self)
	end

	return body
end

function Body:destroy()
	self.entity:removeComponent(self)
end

function Body:start()
	self.transform = assert(self.entity.components.transform)
	local world = assert(self.entity.game.systems.physics.world)
	self.body = love.physics.newBody(world,
		self.transform.x, self.transform.y, "dynamic")
end

function Body:stop()
	self.body:destroy()
	self.body = nil
end

function Body:update(dt)
	print(self.body:getPosition())
end

return Body
