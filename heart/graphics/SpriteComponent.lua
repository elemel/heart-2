local SpriteComponent = {}
SpriteComponent.__index = SpriteComponent

function SpriteComponent.new(system, entity, config)
  local component = setmetatable({}, SpriteComponent)

  component.system = assert(system)
  component.system.spriteComponents[component] = true

  component.entity = assert(entity)
  component.entity:addComponent(component)

  component.boneComponent = assert(component.entity:getComponent("bone"))
  component.image = love.graphics.newImage(config.image)
  component.image:setFilter("nearest", "nearest")

  return component
end

function SpriteComponent:destroy()
  self.boneComponent = nil

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
    componentType = "sprite",
  }
end

return SpriteComponent
