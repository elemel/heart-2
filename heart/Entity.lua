local common = require("heart.common")

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
  self.components[component:getComponentType()] = component
end

function Entity:removeComponent(component)
  self.components[component:getComponentType()] = nil
  common.removeArrayValue(self.components, component)
end

function Entity:getComponent(type)
  return self.components[type]
end

function Entity:getAncestorComponent(type)
  local current = self

  repeat
    local component = current.components[type]

    if component then
      return component
    end

    current = current.parent
  until not current
end

function Entity:getDescendantComponents(type, result)
  result = result or {}

  if self.components[type] then
    table.insert(result, self.components[type])
  end

  for i, child in ipairs(self.children) do
    child:getDescendantComponents(type, result)
  end

  return result
end

function Entity:getConfig()
  local config = {}

  if self.components[1] then
    config.components = {}

    for i, component in ipairs(self.components) do
      table.insert(config.components, component:getConfig())
    end
  end

  if self.children[1] then
    config.children = {}

    for i, child in ipairs(self.children) do
      table.insert(config.children, child:getConfig())
    end
  end

  return config
end

return Entity
