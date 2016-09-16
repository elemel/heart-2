local common = require("heart.common")

local Entity = {}
Entity.__index = Entity

function Entity.new(game, config)
  local entity = setmetatable({}, Entity)
  entity:init(game, config)
  return entity
end

function Entity:init(game, config)
  self.uuid = config.uuid or tostring(love.math.random(0, 65536))

  self.game = assert(game)
  game:addEntity(self)

  self.components = {}

  if config.components then
    for i, componentConfig in ipairs(config.components) do
      self.game:loadComponent(self, componentConfig)
    end
  end
end

function Entity:destroy()
  if self.children then
    for i = #self.children, 1, -1 do
      self.children[i]:destroy()
    end
  end

  if self.components then
    for i = #self.components, 1, -1 do
      self.components[i]:destroy()
    end
  end

  if self.game then
    self.game:removeEntity(self)
    self.game = nil
  end
end

function Entity:getParent()
  return self.parent
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
  common.removeArrayValue(self.components, component)
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

  return config
end

return Entity
