local BorderWidget = {}
BorderWidget.__index = BorderWidget

function BorderWidget.new()
  local widget = setmetatable({}, BorderWidget)
  widget:init()
  return widget
end

function BorderWidget:init()
  self.x, self.y = 0, 0
  self.width, self.height = 0, 0

  self.leftBorder = 0
  self.topBorder = 0
  self.rightBorder = 0
  self.bottomBorder = 0

  self.contentWidth, self.contentHeight = 0, 0
  self.dirty = false
  self.callbacks = {}
end

function BorderWidget:getBounds()
  return self.x, self.y, self.width, self.height
end

function BorderWidget:isDirty()
  return self.dirty
end

function BorderWidget:setDirty(dirty)
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

function BorderWidget:getChild()
  return self.child
end

function BorderWidget:setChild(child)
  if self.child then
    self.child.parent = nil
  end

  self.child = child

  if self.child then
    self.child.parent = self
  end

  self:setDirty(true)
end

function BorderWidget:getBorders()
  return self.leftBorder, self.topBorder, self.rightBorder, self.bottomBorder
end

function BorderWidget:setBorders(leftBorder, topBorder, rightBorder, bottomBorder)
  assert(leftBorder)
  topBorder = topBorder or leftBorder
  rightBorder = rightBorder or leftBorder
  bottomBorder = bottomBorder or topBorder

  if leftBorder ~= self.leftBorder or topBorder ~= self.topBorder or
      rightBorder ~= self.rightBorder or bottomBorder ~= self.bottomBorder then
    self.leftBorder = leftBorder
    self.topBorder = topBorder
    self.rightBorder = rightBorder
    self.bottomBorder = bottomBorder

    self:setDirty(true)
  end
end

function BorderWidget:getColor()
  return self.color
end

function BorderWidget:setColor(color)
  self.color = color
end

function BorderWidget:getBackgroundColor()
  return self.backgroundColor
end

function BorderWidget:setBackgroundColor(color)
  self.backgroundColor = color
end

function BorderWidget:getTargetDimensions()
  if self.child then
    self.contentWidth, self.contentHeight = self.child:getTargetDimensions()
  else
    self.contentWidth, self.contentHeight = 0, 0
  end

  return self.leftBorder + self.contentWidth + self.rightBorder,
    self.topBorder + self.contentHeight + self.bottomBorder
end

function BorderWidget:setBounds(x, y, width, height)
  self.x, self.y = x, y
  self.width, self.height = width, height

  if self.child then
    self.child:setBounds(self.leftBorder, self.topBorder,
      self.width - self.leftBorder - self.rightBorder,
      self.height - self.topBorder - self.bottomBorder)
  end

  self.dirty = false
end

function BorderWidget:draw(x, y)
  if self.backgroundColor then
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle("fill", x + self.x, y + self.y, self.width, self.height)
  end

  if self.child then
    self.child:draw(x + self.x, y + self.y)
  end
end

function BorderWidget:mousepressed(x, y, button, istouch)
  if self.child then
    return self.child:mousepressed(x - self.x, y - self.y, button, istouch)
  end

  return false
end

function BorderWidget:getCallback(name)
  return self.callbacks[name]
end

function BorderWidget:setCallback(name, callback)
  self.callbacks[name] = callback
end

return BorderWidget
