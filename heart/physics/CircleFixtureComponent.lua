local CircleFixtureComponent = {}
CircleFixtureComponent.__index = CircleFixtureComponent

function CircleFixtureComponent.new(system, entity, config)
  local component = setmetatable({}, CircleFixtureComponent)

  component.componentType = "circleFixture"

  component.entity = assert(entity)
  component.entity:addComponent(component)

  local body = assert(component.entity:getAncestorComponent("body"))
  local radius = config.radius or 1
  local shape = love.physics.newCircleShape(radius)
  component.fixture = love.physics.newFixture(body.body, shape)
  component.fixture:setUserData(fixture)
  component.fixture:setFriction(0.5)

  return component
end

function CircleFixtureComponent:destroy()
  self.fixture:destroy()
  self.fixture = nil

  self.entity.removeComponent(self)
  self.entity = nil
end

function CircleFixtureComponent:getComponentType()
  return "circleFixture"
end

function CircleFixtureComponent:getConfig()
  return {
    componentType = "circleFixture",
  }
end

return CircleFixtureComponent
