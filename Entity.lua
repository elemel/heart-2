local common = require "common"

local Entity = {}
Entity.__index = Entity

function Entity.new()
  local entity = setmetatable({}, Entity)
  entity.components = {}
  entity.children = {}
  return entity
end

function Entity:getParent()
  return self.parent
end

function Entity:setParent(parent)
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

function Entity:addComponent(component)
  table.insert(self.components, component)
  self.components[component.name] = component
  component.entity = self
  component:start()
end

function Entity:removeComponent(component)
  component:stop()
  component.entity = nil
  self.components[component.name] = nil
  common.removeArrayValue(self.components, component)
end

function Entity:getComponent(name)
  return self.components[name]
end

function Entity:getAncestorComponent(name)
  local current = self

  repeat
    local component = current.components.name

    if component then
      return component
    end

    current = current.parent
  until not current
end

return Entity
