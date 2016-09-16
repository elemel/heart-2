local common = require("heart.common")

local Entity = {}
Entity.__index = Entity

function Entity.new(game, parent, config)
  local entity = setmetatable({}, Entity)
  entity:init(game, parent, config)
  return entity
end

function Entity:init(game, parent, config)
  self.uuid = config.uuid or tostring(love.math.random(0, 65536))

  self.game = assert(game)
  game:addEntity(self)

  self:setParent(parent)

  self.components = {}

  if config.components then
    for i, componentConfig in ipairs(config.components) do
      self.game:loadComponent(self, componentConfig)
    end
  end

  self.children = {}

  if config.children then
    for i, childConfig in ipairs(config.children) do
      Entity.new(game, self, childConfig)
    end
  end
end

function Entity:destroy()
  if self.children then
    for i = #self.children, 1, -1 do
      self.children[i]:destroy()
    end

    self.children = nil
  end

  if self.components then
    for i = #self.components, 1, -1 do
      self.components[i]:destroy()
    end

    self.components = nil
  end

  if self.game then
    self.game:removeEntity(self)
    self.game = nil
  end
end

function Entity:getParent()
  return self.parent
end

function Entity:setParent(parent)
  if parent ~= self.parent then
    if self.parent then
      common.removeLastArrayValue(self.parent.children, self)
    end

    self.parent = parent

    if self.parent then
      table.insert(self.parent.children, self)
    end
  end
end

function Entity:getUuid()
  return self.uuid
end

function Entity:addComponent(component)
  table.insert(self.components, component)
  self.components[component:getComponentType()] = component
end

function Entity:removeComponent(component)
  self.components[component:getComponentType()] = nil
  common.removeLastArrayValue(self.components, component)
end

function Entity:getComponent(key)
  return self.components[key]
end

function Entity:getConfig()
  local config = {
    uuid = self.uuid,
  }

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

function Entity:getAncestorComponent(type)
  local ancestor = self

  repeat
    if ancestor.components[type] then
      return ancestor.components[type]
    end

    ancestor = ancestor.parent
  until not ancestor

  return nil
end

function Entity:getParentAncestorComponent(type)
  return self.parent and self.parent:getAncestorComponent(type)
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

return Entity
