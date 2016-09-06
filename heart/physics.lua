local physics = {}

local PhysicsSystem = {}
PhysicsSystem.__index = PhysicsSystem

function physics.newPhysicsSystem(config)
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
  local body = physics.newBody(config)
  self.bodies[body] = true
  entity:addComponent(body)
end

local Body = {}
Body.__index = Body

function physics.newBody(data)
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
  local world = assert(self.entity.game.systems.physics.world)
  self.transform = assert(self.entity:getComponent("transform"))
  local x, y = self.transform:getPosition()
  self.body = love.physics.newBody(world, x, y, "dynamic")
  self.body:setUserData(self)
end

function Body:stop()
  self.body:destroy()
  self.body = nil
end

return physics
