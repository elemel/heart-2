local common = require "heart.common"

local ParentingComponent = {}
ParentingComponent.__index = ParentingComponent

function ParentingComponent.new(system, entity, config)
  local component = setmetatable({}, ParentingComponent)
  component:init(system, entity, config)
  return component
end

function ParentingComponent:init(system, entity, config)
  self.entity = assert(entity)
  self.entity:addComponent(self)

  self.children = {}

  if config.parentEntityUuid then
    local entity = system.game:getEntity(config.parentEntityUuid)

    if entity then
      local parent = assert(entity:getComponent("parenting"))
      self:setParent(parent)
    end
  end
end

function ParentingComponent:destroy()
  if self.children then
    for i = #self.children, 1, -1 do
      self.children[i].entity:destroy()
    end

    self.children = nil
  end

  self:setParent(nil)

  if self.entity then
    self.entity:removeComponent(self)
    self.entity = nil
  end
end

function ParentingComponent:getComponentType()
  return "parenting"
end

function ParentingComponent:getConfig()
  local parentEntityUuid = self.parent and self.parent.entity:getUuid()

  return {
    componentType = "parenting",
    parentEntityUuid = parentEntityUuid,
  }
end

function ParentingComponent:getParent()
  return self.parent
end

function ParentingComponent:setParent(parent)
  if parent ~= self.parent then
    if self.parent then
      common.removeArrayValue(self.parent.children, self)
    end

    self.parent = parent

    if self.parent then
      table.insert(self.parent.children, self)
    end
  end
end

function ParentingComponent:getAncestorComponent(type)
  local current = self

  repeat
    local component = current.entity:getComponent(type)

    if component then
      return component
    end

    current = current.parent
  until not current

  return nil
end

function ParentingComponent:getParentAncestorComponent(type)
  return self.parent and self.parent:getAncestorComponent(type)
end

function ParentingComponent:getDescendantComponents(type, result)
  result = result or {}
  local component = self.entity:getComponent(type)

  if component then
    table.insert(result, component)
  end

  for i, child in ipairs(self.children) do
    child:getDescendantComponents(type, result)
  end

  return result
end

return ParentingComponent
