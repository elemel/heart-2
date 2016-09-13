local PhysicsSystem = {}
PhysicsSystem.__index = PhysicsSystem

function PhysicsSystem.new(game, config)
  local system = setmetatable({}, PhysicsSystem)
  system:init(game, config)
  return system
end

function PhysicsSystem:init(game, config)
  self.game = assert(game)
  self.game:addSystem(self)

  self.bodyComponents = {}

  local gravityX = config.gravity and config.gravity.x or 0
  local gravityY = config.gravity and config.gravity.y or 0
  local allowSleeping = config.allowSleeping or true

  self.world = love.physics.newWorld(gravityX, gravityY, allowSleeping)
end

function PhysicsSystem:destroy()
  if self.world then
    self.world:destroy()
    self.world = nil
  end

  if self.game then
    self.game:removeSystem(self)
    self.game = nil
  end
end

function PhysicsSystem:getSystemType()
  return "physics"
end

function PhysicsSystem:getConfig()
  local gravityX, gravityY = self.world:getGravity()

  return {
    systemType = "physics",

    gravity = {
      x = gravityX,
      y = gravityY,
    },
  }
end

function PhysicsSystem:update(dt)
  self.world:update(dt)

  for component, _ in pairs(self.bodyComponents) do
    component.boneComponent:setWorldPosition(component.body:getPosition())
    component.boneComponent:setWorldAngle(component.body:getAngle())
  end
end

function PhysicsSystem:draw()
end

function PhysicsSystem:debugDraw()
  for i, body in ipairs(self.world:getBodyList()) do
    for i, fixture in ipairs(body:getFixtureList()) do
      local shape = fixture:getShape()
      local shapeType = shape:getType()

      if shapeType == "polygon" then
        love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
      elseif shapeType == "circle" then
        love.graphics.push()

        local x, y = body:getWorldPoint(shape:getPoint())
        local angle = body:getAngle()
        local radius = shape:getRadius()

        love.graphics.translate(x, y)
        love.graphics.rotate(angle)
        love.graphics.circle("line", 0, 0, radius, 16)
        love.graphics.line(0, 0, radius, 0)

        love.graphics.pop()
      end
    end
  end
end

return PhysicsSystem
