local BodyComponent = {}
BodyComponent.__index = BodyComponent

function BodyComponent.new(system, entity, config)
  local component = setmetatable({}, BodyComponent)

  component.system = assert(system)
  component.system.bodyComponents[component] = true

  component.entity = assert(entity)
  component.entity:addComponent(component)

  component.transformComponent = assert(component.entity:getComponent("transform"))

  local world = assert(component.system.world)
  local x, y = component.transformComponent:getPosition()
  component.body = love.physics.newBody(world, x, y, config.bodyType)
  component.body:setUserData(component)

  return component
end

function BodyComponent:destroy()
  self.body:destroy()
  self.body = nil

  self.transformComponent = nil

  self.entity:removeComponent(self)
  self.entity = nil

  self.system.bodyComponents[self] = nil
  self.system = nil
end

function BodyComponent:getComponentType()
  return "body"
end

function BodyComponent:getConfig()
  return {
    type = "body",
  }
end

return BodyComponent
