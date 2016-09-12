local CircleFixtureComponent = {}
CircleFixtureComponent.__index = CircleFixtureComponent

function CircleFixtureComponent.new(system, entity, config)
  local component = setmetatable({}, CircleFixtureComponent)
  component:init(system, entity, config)
  return component
end

function CircleFixtureComponent:init(system, entity, config)
  self.componentType = "circleFixture"

  self.entity = assert(entity)
  self.entity:addComponent(self)

  local parentingComponent = self.entity:getComponent("parenting")
  local bodyComponent

  if parentingComponent then
    bodyComponent = assert(parentingComponent:getAncestorComponent("body"))
  else
    bodyComponent = assert(self.entity:getComponent("body"))
  end

  local radius = config.radius or 1
  local shape = love.physics.newCircleShape(radius)

  self.fixture = love.physics.newFixture(bodyComponent.body, shape)
  self.fixture:setUserData(self)
  self.fixture:setFriction(0.5)
end

function CircleFixtureComponent:destroy()
  if self.fixture then
    self.fixture:destroy()
    self.fixture = nil
  end

  if self.entity then
    self.entity.removeComponent(self)
    self.entity = nil
  end
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
