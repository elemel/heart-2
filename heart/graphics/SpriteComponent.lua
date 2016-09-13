local SpriteComponent = {}
SpriteComponent.__index = SpriteComponent

function SpriteComponent.new(system, entity, config)
  local component = setmetatable({}, SpriteComponent)
  component:init(system, entity, config)
  return component
end

function SpriteComponent:init(system, entity, config)
  self.system = assert(system)
  self.system.spriteComponents[self] = true

  self.entity = assert(entity)
  self.entity:addComponent(self)

  self.boneComponent = assert(self.entity:getComponent("bone"))

  self.imagePath = assert(config.imagePath)
  self.image = love.graphics.newImage(self.imagePath)
  self.image:setFilter("nearest", "nearest")
end

function SpriteComponent:destroy()
  self.image = nil
  self.boneComponent = nil

  if self.entity then
    self.entity:removeComponent(self)
    self.entity = nil
  end

  if self.system then
    self.system.sprites[self] = nil
    self.system = nil
  end
end

function SpriteComponent:getComponentType()
  return "sprite"
end

function SpriteComponent:getConfig()
  return {
    componentType = "sprite",
    imagePath = self.imagePath,
  }
end

return SpriteComponent
