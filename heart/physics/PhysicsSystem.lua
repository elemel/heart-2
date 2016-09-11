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

function PhysicsSystem:getConfig()
  return {
    systemType = "physics",
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
