local SpriteComponent = {}
SpriteComponent.__index = SpriteComponent

function SpriteComponent.new(system, entity, config)
  local component = setmetatable({}, SpriteComponent)

  component.system = assert(system)
  component.system.spriteComponents[component] = true

  component.entity = assert(entity)
  component.entity:addComponent(component)

  component.transformComponent = assert(component.entity:getComponent("transform"))
  component.image = love.graphics.newImage(config.image)
  component.image:setFilter("nearest", "nearest")

  return component
end

function SpriteComponent:destroy()
  self.transformComponent = nil

  self.entity:removeComponent(self)
  self.entity = nil

  self.system.sprites[self] = nil
  self.system = nil
end

function SpriteComponent:getComponentType()
  return "sprite"
end

function SpriteComponent:getConfig()
  return {
    type = "sprite",
  }
end

return SpriteComponent
