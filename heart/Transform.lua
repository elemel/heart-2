local Matrix = require "heart.Matrix"

local transform = {}

local TransformSystem = {}
TransformSystem.__index = TransformSystem

function transform.newTransformSystem(game, config)
  local system = setmetatable({}, TransformSystem)

  system.name = "transform"

  system.game = assert(game)
  system.game:addSystem(system)

  return system
end

function TransformSystem:destroy()
  self.game:removeSystem(self)
  self.game = nil
end

function TransformSystem:update(dt)
end

function TransformSystem:draw()
end

local Transform = {}
Transform.__index = Transform

function transform.newTransform(data)
  local transform = setmetatable({}, Transform)
  transform.name = "transform"

  transform.x = data.x or 0
  transform.y = data.y or 0

  transform.angle = data.angle or 0

  transform.scaleX = data.scaleX or 1
  transform.scaleY = data.scaleY or 1

  transform.localMatrix = Matrix.new()
  transform.matrix = Matrix.new()
  transform.dirty = false

  if data.entity then
    data.entity:addComponent(self)
  end

  return transform
end

function Transform:destroy()
  self.entity:removeComponent(self)
end

function Transform:start()
  self:bindParent()
end

function Transform:stop()
  self.parent = nil
end

function Transform:isDirty()
  return self.dirty
end

function Transform:setDirty(dirty)
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

function Transform:bindParent()
  local parentEntity = self.entity and self.entity.parent

  while entity ~= nil do
    if entity.transform then
      self.parent = entity.transform
      break
    end

    entity = entity.parent
  end
end

function Transform:getPosition()
  return self.x, self.y
end

function Transform:setPosition(x, y)
  self.x = x
  self.y = y
  self.dirty = true
end

function Transform:getAngle()
  return self.angle
end

function Transform:setAngle(angle)
  self.angle = angle
  self.dirty = true
end

return transform
