local RectangleFixtureComponent = {}
RectangleFixtureComponent.__index = RectangleFixtureComponent

function RectangleFixtureComponent.new(system, entity, config)
  local component = setmetatable({}, RectangleFixtureComponent)
  component:init(system, entity, config)
  return component
end

function RectangleFixtureComponent:init(system, entity, config)
  self.entity = assert(entity)
  self.entity:addComponent(self)

  local parentingComponent = self.entity:getComponent("parenting")
  local bodyComponent

  if parentingComponent then
    bodyComponent = assert(parentingComponent:getAncestorComponent("body"))
  else
    bodyComponent = assert(self.entity:getComponent("body"))
  end

  local width = config.width or 1
  local height = config.height or 1
  local angle = config.angle or 0
  local shape = love.physics.newRectangleShape(0, 0, width, height, angle)

  self.fixture = love.physics.newFixture(bodyComponent.body, shape)
  self.fixture:setUserData(self)
  self.fixture:setFriction(0.5)
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
    componentType = "rectangleFixture",
  }
end

return RectangleFixtureComponent
