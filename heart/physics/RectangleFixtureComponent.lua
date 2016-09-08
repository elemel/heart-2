local RectangleFixtureComponent = {}
RectangleFixtureComponent.__index = RectangleFixtureComponent

function RectangleFixtureComponent.new(system, entity, config)
  local component = setmetatable({}, RectangleFixtureComponent)

  component.entity = assert(entity)
  component.entity:addComponent(component)

  local body = assert(component.entity:getAncestorComponent("body"))
  local width = config.width or 1
  local height = config.height or 1
  local angle = config.angle or 0
  local shape = love.physics.newRectangleShape(0, 0, width, height, angle)
  component.fixture = love.physics.newFixture(body.body, shape)
  component.fixture:setUserData(component)
  component.fixture:setFriction(0.5)

  return component
end

function RectangleFixtureComponent:destroy()
  self.fixture:destroy()
  self.fixture = nil

  self.entity.removeComponent(self)
  self.entity = nil
end

function RectangleFixtureComponent:getComponentType()
  return "rectangleFixture"
end

function RectangleFixtureComponent:getConfig()
  return {
    type = "rectangleFixture",
  }
end

return RectangleFixtureComponent
