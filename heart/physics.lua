local physics = {}

local PhysicsSystem = {}
PhysicsSystem.__index = PhysicsSystem

function physics.newPhysicsSystem(game, config)
  local system = setmetatable({}, PhysicsSystem)

  system.game = assert(game)
  system.name = "physics"
  system.bodies = {}

  local gravityX = config.gravityX or 0
  local gravityY = config.gravityY or -10
  local allowSleeping = config.allowSleeping or true

  system.world = love.physics.newWorld(gravityX, gravityY, allowSleeping)
  system.game:addSystem(system)

  return system
end

function PhysicsSystem:destroy()
  self.world:destroy()
  self.world = nil

  self.game:removeSystem(self)
  self.game = nil
end

function PhysicsSystem:update(dt)
  self.world:update(dt)

  for body, _ in pairs(self.bodies) do
    body.transform:setPosition(body.body:getPosition())
    body.transform:setAngle(body.body:getAngle())
  end
end

function PhysicsSystem:draw()
end

local Body = {}
Body.__index = Body

function physics.newBody(system, entity, config)
  local body = setmetatable({}, Body)

  body.name = "body"

  body.system = assert(system)
  body.system.bodies[body] = true

  body.entity = assert(entity)
  body.entity:addComponent(body)

  body.transform = assert(body.entity:getComponent("transform"))

  local world = assert(body.system.world)
  local x, y = body.transform:getPosition()
  body.body = love.physics.newBody(world, x, y, "dynamic")
  body.body:setUserData(body)

  return body
end

function Body:destroy()
  self.body:destroy()
  self.body = nil

  self.transform = nil

  self.entity:removeComponent(self)
  self.entity = nil

  self.system.bodies[self] = nil
  self.system = nil
end

return physics
