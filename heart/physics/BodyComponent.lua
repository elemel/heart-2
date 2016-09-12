local BodyComponent = {}
BodyComponent.__index = BodyComponent

function BodyComponent.new(system, entity, config)
  local component = setmetatable({}, BodyComponent)
  component:init(system, entity, config)
  return component
end

function BodyComponent:init(system, entity, config)
  self.system = assert(system)
  self.system.bodyComponents[self] = true

  self.entity = assert(entity)
  self.entity:addComponent(self)

  self.boneComponent = assert(self.entity:getComponent("bone"))

  local world = assert(self.system.world)
  local x, y = self.boneComponent:getWorldPosition()
  local angle = self.boneComponent:getWorldAngle()

  self.body = love.physics.newBody(world, x, y, config.bodyType)
  self.body:setAngle(angle)
  self.body:setUserData(self)
end

function BodyComponent:destroy()
  if self.body then
    self.body:destroy()
    self.body = nil
  end

  self.boneComponent = nil

  if self.entity then
    self.entity:removeComponent(self)
    self.entity = nil
  end

  if self.system then
    self.system.bodyComponents[self] = nil
    self.system = nil
  end
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
