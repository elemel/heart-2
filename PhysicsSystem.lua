local Body = require "Body"

local PhysicsSystem = {}
PhysicsSystem.__index = PhysicsSystem

function PhysicsSystem.new(config)
  local system = setmetatable({}, PhysicsSystem)
  system:init(config)
  return system
end

function PhysicsSystem:init(config)
  self.name = "physics"
  self.bodies = {}
  self.config = config
end

function PhysicsSystem:destroy()
  if self.game then
    self.game:removeSystem(self)
  end
end

function PhysicsSystem:start()
  local gravityX = self.config.gravityX or 0
  local gravityY = self.config.gravityY or -10
  local allowSleeping = self.config.allowSleeping or true

  self.world = love.physics.newWorld(gravityX, gravityY, allowSleeping)
end

function PhysicsSystem:stop()
  self.world:destroy()
end

function PhysicsSystem:update(dt)
  self.world:update(dt)

  for body, _ in pairs(self.bodies) do
    body.transform:setPosition(body.body:getPosition())
    body.transform:setAngle(body.body:getAngle())
  end
end

function PhysicsSystem:loadBody(entity, config)
  local body = Body.new(config)
  self.bodies[body] = true
  entity:addComponent(body)
end

return PhysicsSystem
