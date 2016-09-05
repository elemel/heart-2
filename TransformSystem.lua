local TransformSystem = {}
TransformSystem.__index = TransformSystem

function TransformSystem.new(config)
	local system = setmetatable({}, TransformSystem)
	system.name = "transform"
	system.config = config
	return system
end

function TransformSystem:destroy()
	if self.game then
		self.game:removeSystem(self)
	end
end

function TransformSystem:start()
end

function TransformSystem:stop()
end

function TransformSystem:update(dt)
end

return TransformSystem
