local Matrix = require "Matrix"

local Transform = {}
Transform.__index = Transform

function Transform.new(data)
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
end

function Transform:stop()
end

function Transform:normalize()
  if self.dirty then
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

function Transform:getParent()
  local entity = self.entity and self.entity.parent

  while entity ~= nil do
    if entity.transform then
      return entity.transform
    end

    entity = entity.parent
  end

  return nil
end

return Transform
