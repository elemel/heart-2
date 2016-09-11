local BodyComponent = {}
BodyComponent.__index = BodyComponent

function BodyComponent.new(system, entity, config)
  local component = setmetatable({}, BodyComponent)

  component.system = assert(system)
  component.system.bodyComponents[component] = true

  component.entity = assert(entity)
  component.entity:addComponent(component)

  component.boneComponent = assert(component.entity:getComponent("bone"))

  local world = assert(component.system.world)
  local x, y = component.boneComponent:getWorldPosition()
  local angle = component.boneComponent:getWorldAngle()

  component.body = love.physics.newBody(world, x, y, config.bodyType)
  component.body:setAngle(angle)
  component.body:setUserData(component)

  return component
end

function BodyComponent:destroy()
  self.body:destroy()
  self.body = nil

  self.boneComponent = nil

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
    componentType = "body",
  }
end

return BodyComponent
