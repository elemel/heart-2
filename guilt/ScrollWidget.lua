local ScrollWidget = {}
ScrollWidget.__index = ScrollWidget

function ScrollWidget.new()
  local widget = setmetatable({}, ScrollWidget)
  widget:init()
  return widget
end

function ScrollWidget:init()
  self.targetWidth, self.targetHeight = 0, 0

  self.x, self.y = 0, 0
  self.width, self.height = 0, 0

  self.dirty = false
  self.callbacks = {}
end

function ScrollWidget:isDirty()
  return self.dirty
end

function ScrollWidget:setDirty(dirty)
  assert(type(dirty) == "boolean")

  if dirty ~= self.dirty then
    if dirty then
      self.dirty = true

      if self.parent then
        self.parent:setDirty(true)
      end
    end
  end
end

function ScrollWidget:getChild()
  return self.child
end

function ScrollWidget:setChild(child)
  if self.child then
    self.child.parent = nil
  end

  self.child = child

  if self.child then
    self.child.parent = self
  end

  self:setDirty(true)
end

function ScrollWidget:getScrolls()
  return self.minWidth, self.minHeight, self.maxWidth, self.maxHeight
end

function ScrollWidget:setScrolls(minWidth, minHeight, maxWidth, maxHeight)
  if minWidth ~= self.minWidth or minHeight ~= self.minHeight or
      maxWidth ~= self.maxWidth or maxHeight ~= self.maxHeight then
    self.minWidth = minWidth
    self.minHeight = minHeight
    self.maxWidth = maxWidth
    self.maxHeight = maxHeight

    self:setDirty(true)
  end
end

function ScrollWidget:getBackgroundColor()
  return self.backgroundColor
end

function ScrollWidget:setBackgroundColor(color)
  self.backgroundColor = color
end

function ScrollWidget:getTargetDimensions()
  if self.targetWidth and self.targetHeight then
    return self.targetWidth, self.targetHeight
  end

  local childWidth, childHeight = 0, 0

  if self.child then
    childWidth, childHeight = self.child:getTargetDimensions()
  end

  return self.targetWidth or childWidth, self.targetHeight or childHeight
end

function ScrollWidget:setTargetDimensions(width, height)
  if width ~= self.targetWidth or height ~= self.targetHeight then
    self.targetWidth, self.targetHeight = width, height
    self:setDirty(true)
  end
end

function ScrollWidget:getBounds()
  return self.x, self.y, self.width, self.height
end

function ScrollWidget:setBounds(x, y, width, height)
  self.x, self.y = x, y
  self.width, self.height = width, height

  if self.child then
    self.child:setBounds(0, 0, width, height)
  end

  self.dirty = false
end

function ScrollWidget:draw(x, y)
  if self.backgroundColor then
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle("fill", x + self.x, y + self.y, self.width, self.height)
  end

  if self.child then
    self.child:draw(x + self.x, y + self.y)
  end
end

function ScrollWidget:mousepressed(x, y, button, istouch)
  if self.child then
    return self.child:mousepressed(x - self.x, y - self.y, button, istouch)
  end

  return false
end

function ScrollWidget:getCallback(name)
  return self.callbacks[name]
end

function ScrollWidget:setCallback(name, callback)
  self.callbacks[name] = callback
end

return ScrollWidget
