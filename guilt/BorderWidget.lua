local BorderWidget = {}
BorderWidget.__index = BorderWidget

function BorderWidget.new(gui, parent, config)
  local widget = setmetatable({}, BorderWidget)
  widget:init(gui, parent, config)
  return widget
end

function BorderWidget:init(gui, parent, config)
  self.gui = assert(gui)
  self:setParent(parent)

  self.weight = config.weight or 0

  self.x, self.y = 0, 0
  self.width, self.height = 0, 0
  self.measuredWidth, self.measuredHeight = 0, 0
  self.normalizedWeight = 0, 0

  self.leftBorder = config.border or config.borderX or config.leftBorder or 0
  self.topBorder = config.border or config.borderY or config.topBorder or 0
  self.rightBorder = config.border or config.borderX or config.rightBorder or 0
  self.bottomBorder = config.border or config.borderY or config.bottomBorder or 0

  self.children = {}
  self.callbacks = {}
end

function BorderWidget:destroy()
  for i = #self.children, 1, -1 do
    local child = self.children[i]
    child:destroy()
  end

  self:setParent(nil)
end

function BorderWidget:getParent()
  return self.parent
end

function BorderWidget:setParent(parent)
  if parent ~= self.parent then
    if self.parent then
      self.parent:removeChild(self)
    end

    self.parent = parent

    if self.parent then
      self.parent:addChild(self)
    end
  end
end

function BorderWidget:addChild(child)
  table.insert(self.children, child)
end

function BorderWidget:removeChild(child)
  for i = #self.children, 1, -1 do
    local sibling = self.children[i]

    if sibling == child then
      table.remove(self.children, i)
      break
    end
  end
end

function BorderWidget:getWeight()
  return self.weight
end

function BorderWidget:setWeight(weight)
  self.weight = weight
end

function BorderWidget:getCallback(name)
  return self.callbacks[name]
end

function BorderWidget:setCallback(name, callback)
  self.callbacks[name] = callback
end

function BorderWidget:getBorder()
  return self.leftBorder, self.topBorder, self.rightBorder, self.bottomBorder
end

function BorderWidget:setBorder(left, top, right, bottom)
  self.leftBorder = assert(left)
  self.topBorder = top or self.leftBorder
  self.rightBorder = right or self.leftBorder
  self.bottomBorder = bottom or self.topBorder
end

function BorderWidget:getBounds()
  return self.x, self.y, self.width, self.height
end

function BorderWidget:measure()
  self.measuredWidth, self.measuredHeight = 0, 0

  for i, child in ipairs(self.children) do
    local width, height = child:measure()

    self.measuredWidth = math.max(self.measuredWidth, width)
    self.measuredHeight = math.max(self.measuredHeight, height)
  end

  local scale = self.gui:getScale()

  self.measuredWidth = self.measuredWidth + scale * (self.leftBorder + self.rightBorder)
  self.measuredHeight = self.measuredHeight + scale * (self.topBorder + self.bottomBorder)

  return self.measuredWidth, self.measuredHeight
end

function BorderWidget:arrange(x, y, width, height)
  self.x, self.y = x, y
  self.width, self.height = width, height

  local scale = self.gui:getScale()

  local childWidth = width - scale * (self.leftBorder + self.rightBorder)
  local childHeight = height - scale * (self.topBorder + self.bottomBorder)

  for i, child in ipairs(self.children) do
    child:arrange(scale * self.leftBorder, scale * self.topBorder, childWidth, childHeight)
  end
end

function BorderWidget:draw(x, y)
  for i, child in ipairs(self.children) do
    child:draw(x + self.x, y + self.y)
  end
end

return BorderWidget
