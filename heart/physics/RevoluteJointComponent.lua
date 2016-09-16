local RevoluteJointComponent = {}
RevoluteJointComponent.__index = RevoluteJointComponent

function RevoluteJointComponent.new(system, entity, config)
  local component = setmetatable({}, RevoluteJointComponent)
  component:init(system, entity, config)
  return component
end

function RevoluteJointComponent:init(system, entity, config)
  self.entity = assert(entity)
  self.entity:addComponent(self)

  local bodyComponent = assert(self.entity:getAncestorComponent("body"))
  local parentBodyComponent = assert(bodyComponent.entity:getParentAncestorComponent("body"))
  local boneComponent = assert(self.entity:getAncestorComponent("bone"))

  local x, y = boneComponent:getWorldPosition()
  local collideConnected = config.collideConnected or false
  self.joint = love.physics.newRevoluteJoint(parentBodyComponent.body, bodyComponent.body,
    x, y, collideConnected)
end

function RevoluteJointComponent:destroy()
  if self.joint then
    self.joint:destroy()
    self.joint = nil
  end

  if self.entity then
    self.entity.removeComponent(self)
    self.entity = nil
  end
end

function RevoluteJointComponent:getComponentType()
  return "revoluteJoint"
end

function RevoluteJointComponent:getConfig()
  return {
    componentType = "revoluteJoint",
  }
end

return RevoluteJointComponent
