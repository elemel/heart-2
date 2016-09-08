local PhysicsSystem = {}
PhysicsSystem.__index = PhysicsSystem

function PhysicsSystem.new(game, config)
  local system = setmetatable({}, PhysicsSystem)

  system.game = assert(game)
  system.game:addSystem(system)

  system.bodyComponents = {}

  local gravityX = config.gravityX or 0
  local gravityY = config.gravityY or -10
  local allowSleeping = config.allowSleeping or true

  system.world = love.physics.newWorld(gravityX, gravityY, allowSleeping)

  return system
end

function PhysicsSystem:destroy()
  self.world:destroy()
  self.world = nil

  self.game:removeSystem(self)
  self.game = nil
end

function PhysicsSystem:getSystemType()
  return "physics"
end

function PhysicsSystem:update(dt)
  self.world:update(dt)

  for component, _ in pairs(self.bodyComponents) do
    component.transformComponent:setPosition(component.body:getPosition())
    component.transformComponent:setAngle(component.body:getAngle())
  end
end

function PhysicsSystem:draw()
end

return PhysicsSystem
