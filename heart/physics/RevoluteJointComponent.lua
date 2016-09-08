local RevoluteJointComponent = {}
RevoluteJointComponent.__index = RevoluteJointComponent

function RevoluteJointComponent.new(system, entity, config)
  local component = setmetatable({}, RevoluteJointComponent)

  component.entity = assert(entity)
  component.entity:addComponent(component)

  local body = assert(component.entity:getAncestorComponent("body"))
  local parentBody = assert(body.entity.parent:getAncestorComponent("body"))
  local transform = assert(component.entity:getAncestorComponent("transform"))
  local x, y = transform:getPosition()
  local collideConnected = config.collideConnected or false
  component.joint = love.physics.newRevoluteJoint(parentBody.body, body.body,
    x, y, collideConnected)

  return component
end

function RevoluteJointComponent:destroy()
  self.joint:destroy()
  self.joint = nil

  self.entity.removeComponent(self)
  self.entity = nil
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
