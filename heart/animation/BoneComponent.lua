local heartMath = require("heart.math")

local BoneComponent = {}
BoneComponent.__index = BoneComponent

function BoneComponent.new(system, entity, config)
  local component = setmetatable({}, BoneComponent)
  component:init(system, entity, config)
  return component
end

function BoneComponent:init(system, entity, config)
  self.system = assert(system)
  self.system.boneComponents[self] = true

  self.entity = assert(entity)
  self.entity:addComponent(self)

  self.x = config.position and config.position.x or 0
  self.y = config.position and config.position.y or 0

  self.angle = config.angle or 0
  self.scale = config.scale or 1

  self.worldX = 0
  self.worldY = 0

  self.worldAngle = 0
  self.worldScale = 1

  self.matrix = heartMath.newMatrix()
  self.worldMatrix = heartMath.newMatrix()
  self.invWorldMatrix = heartMath.newMatrix()

  self.dirty = true

  self:bindParent()
end

function BoneComponent:destroy()
  if self.entity then
    self.entity:removeComponent(self)
    self.entity = nil
  end

  if self.system then
    self.system.boneComponents[self] = nil
    self.system = nil
  end
end

function BoneComponent:getComponentType()
  return "bone"
end

function BoneComponent:getConfig()
  return {
    componentType = "bone",

    position = {
      x = self.x,
      y = self.y,
    },

    angle = self.angle,
    scale = self.scale,
  }
end

function BoneComponent:isDirty()
  return self.dirty
end

function BoneComponent:setDirty(dirty)
  assert(type(dirty) == "boolean")

  if dirty ~= self.dirty then
    if self.dirty then
      self.matrix:reset()
      self.matrix:translate(self.x, self.y)
      self.matrix:rotate(self.angle)
      self.matrix:scale(self.scale, self.scale)

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
    end

    self.dirty = dirty
  end
end

function BoneComponent:bindParent()
  self.parent = self.entity:getParentAncestorComponent("bone")
  self.dirty = true
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
