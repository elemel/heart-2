local heartMath = require("heart.math")

local BoneComponent = {}
BoneComponent.__index = BoneComponent

function BoneComponent.new(system, entity, config)
  local component = setmetatable({}, BoneComponent)

  component.entity = assert(entity)
  component.entity:addComponent(component)

  component.x = config.position and config.position.x or 0
  component.y = config.position and config.position.y or 0

  component.angle = config.angle or 0

  component.scaleX = config.scale and config.scale.x or 1
  component.scaleY = config.scale and config.scale.y or 1

  component.worldX = 0
  component.worldY = 0

  component.worldAngle = 0

  component.worldScaleX = 1
  component.worldScaleY = 1

  component.matrix = heartMath.newMatrix()
  component.worldMatrix = heartMath.newMatrix()
  component.invWorldMatrix = heartMath.newMatrix()

  component.dirty = true

  component:bindParent()

  return component
end

function BoneComponent:destroy()
  self.entity:removeComponent(self)
  self.entity = nil
end

function BoneComponent:getComponentType()
  return "bone"
end

function BoneComponent:getConfig()
  return {
    componentType = "bone",
    position = {x = self.x, y = self.y},
    angle = self.angle,
    scale = {x = self.scaleX, y = self.scaleY},
  }
end

function BoneComponent:start()
  self:bindParent()
end

function BoneComponent:stop()
  self.parent = nil
end

function BoneComponent:isDirty()
  return self.dirty
end

function BoneComponent:setDirty(dirty)
  assert(type(dirty) == "boolean")

  if dirty ~= self.dirty then
    if dirty then
      self.dirty = true
    elseif self.dirty then
      self.matrix:reset()
      self.matrix:translate(self.x, self.y)
      self.matrix:rotate(self.angle)
      self.matrix:scale(self.scaleX, self.scaleY)

      self.worldMatrix:reset(self.matrix:get())

      if self.parent then
        self.parent:setDirty(false)
        self.worldMatrix:multiplyRight(self.parent.worldMatrix:get())
      end

      self.invWorldMatrix:reset(self.worldMatrix:get())
      self.invWorldMatrix:invert()

      self.worldX, self.worldY = self.worldMatrix:transformPoint(0, 0)
      self.worldAngle = self.angle

      if self.parent then
        self.worldAngle = self.worldAngle - self.parent.angle
      end

      self.dirty = false
    end
  end
end

function BoneComponent:bindParent()
  local entity = self.entity and self.entity.parent

  while entity ~= nil do
    local parent = entity:getComponent("bone")

    if parent then
      self.parent = parent
      self.dirty = true
      break
    end

    entity = entity.parent
  end
end

function BoneComponent:getPosition()
  return self.x, self.y
end

function BoneComponent:setPosition(x, y)
  self.x = x
  self.y = y
  self.dirty = true
end

function BoneComponent:getAngle()
  self:setDirty(false)
  return self.angle
end

function BoneComponent:setAngle(angle)
  self.angle = angle
  self.dirty = true
end

function BoneComponent:getWorldPosition()
  self:setDirty(false)
  return self.worldX, self.worldY
end

function BoneComponent:setWorldPosition(x, y)
  self:setDirty(false)

  if self.parent then
    x, y = self.parent.invWorldMatrix:transformPoint(x, y)
  end

  self.x, self.y = x, y
  self.dirty = true
end

function BoneComponent:getWorldAngle()
  self:setDirty(false)
  return self.worldAngle
end

function BoneComponent:setWorldAngle(angle)
  self:setDirty(false)

  if self.parent then
    angle = angle - self.parent.worldAngle
  end

  self.angle = angle
  self.dirty = true
end

return BoneComponent
