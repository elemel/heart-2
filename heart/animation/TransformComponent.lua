local heartMath = require("heart.math")

local TransformComponent = {}
TransformComponent.__index = TransformComponent

function TransformComponent.new(system, entity, config)
  local component = setmetatable({}, TransformComponent)

  component.entity = assert(entity)
  component.entity:addComponent(component)

  component.x = config.x or 0
  component.y = config.y or 0

  component.angle = config.angle or 0

  component.scaleX = config.scaleX or 1
  component.scaleY = config.scaleY or 1

  component.localMatrix = heartMath.newMatrix()
  component.matrix = heartMath.newMatrix()
  component.dirty = false

  return component
end

function TransformComponent:destroy()
  self.entity:removeComponent(self)
  self.entity = nil
end

function TransformComponent:getComponentType()
  return "transform"
end

function TransformComponent:getConfig()
  return {
    componentType = "transform",

    x = self.x,
    y = self.y,

    angle = self.angle,

    scaleX = self.scaleX,
    scaleY = self.scaleY,
  }
end

function TransformComponent:start()
  self:bindParent()
end

function TransformComponent:stop()
  self.parent = nil
end

function TransformComponent:isDirty()
  return self.dirty
end

function TransformComponent:setDirty(dirty)
  assert(type(dirty) == "boolean")

  if dirty ~= self.dirty then
    if dirty then
      self.dirty = true
    elseif self.dirty then
      self.localMatrix:reset()
      self.localMatrix:translate(self.x, self.y)
      self.localMatrix:rotate(self.angle)
      self.localMatrix:scale(self.scaleX, self.scaleY)

      self.matrix:reset(self.localMatrix:get())

      local parent = self:getParent()

      if parent then
        parent:normalize()
        self.matrix:multiplyRight(parent.matrix)
      end

      self.dirty = false
    end
  end
end

function TransformComponent:bindParent()
  local parentEntity = self.entity and self.entity.parent

  while entity ~= nil do
    if entity.transform then
      self.parent = entity.transform
      break
    end

    entity = entity.parent
  end
end

function TransformComponent:getPosition()
  return self.x, self.y
end

function TransformComponent:setPosition(x, y)
  self.x = x
  self.y = y
  self.dirty = true
end

function TransformComponent:getAngle()
  return self.angle
end

function TransformComponent:setAngle(angle)
  self.angle = angle
  self.dirty = true
end

return TransformComponent
