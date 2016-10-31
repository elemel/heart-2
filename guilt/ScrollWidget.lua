local ScrollWidget = {}
ScrollWidget.__index = ScrollWidget

function ScrollWidget.new(gui, parent, config)
  local widget = setmetatable({}, ScrollWidget)
  widget:init(gui, parent, config)
  return widget
end

function ScrollWidget:init(gui, parent, config)
  self.gui = assert(gui)
  self:setParent(parent)

  self.weight = config.weight or 0

  self.minWidth, self.minHeight = config.minWidth, config.minHeight
  self.maxWidth, self.maxHeight = config.maxWidth, config.maxHeight

  self.x, self.y = 0, 0
  self.width, self.height = 0, 0
  self.measuredWidth, self.measuredHeight = 0, 0
  self.normalizedWeight = 0

  self.children = {}
  self.callbacks = {}
end

function ScrollWidget:destroy()
  self:setParent(nil)
  self.gui = nil
end

function ScrollWidget:getParent()
  return self.parent
end

function ScrollWidget:setParent(parent)
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

function ScrollWidget:addChild(child)
  table.insert(self.children, child)
end

function ScrollWidget:removeChild(child)
  for i = #self.children, 1, -1 do
    local sibling = self.children[i]

    if sibling == child then
      table.remove(self.children, i)
      break
    end
  end
end

function ScrollWidget:getWeight()
  return self.weight
end

function ScrollWidget:setWeight(weight)
  self.weight = weight
end

function ScrollWidget:getMinDimensions()
  return self.minWidth, self.minHeight
end

function ScrollWidget:setMinDimensions(width, height)
  self.minWidth = width
  self.minHeight = height
end

function ScrollWidget:getMaxDimensions()
  return self.maxWidth, self.maxHeight
end

function ScrollWidget:setMaxDimensions(width, height)
  self.maxWidth = width
  self.maxHeight = height
end

function ScrollWidget:getCallback(name)
  return self.callbacks[name]
end

function ScrollWidget:setCallback(name, callback)
  self.callbacks[name] = callback
end

function ScrollWidget:measure()
  self.measuredWidth, self.measuredHeight = 0, 0

  for i, child in ipairs(self.children) do
    local width, height = child:measure()

    self.measuredWidth = math.max(self.measuredWidth, width)
    self.measuredHeight = math.max(self.measuredHeight, height)
  end

  local scale = self.gui:getScale()

  if self.minWidth then
    self.measuredWidth = math.max(self.measuredWidth, scale * self.minWidth)
  end

  if self.minHeight then
    self.measuredHeight = math.max(self.measuredHeight, scale * self.minHeight)
  end

  if self.maxWidth then
    self.measuredWidth = math.min(self.measuredWidth, scale * self.maxWidth)
  end

  if self.maxHeight then
    self.measuredHeight = math.min(self.measuredHeight, scale * self.maxHeight)
  end

  return self.measuredWidth, self.measuredHeight
end

function ScrollWidget:arrange(x, y, width, height)
  self.x, self.y = x, y
  self.width, self.height = width, height

  local child = self.children[1]

  if child then
    child:arrange(0, 0, child.measuredWidth, child.measuredHeight)
  end
end

function ScrollWidget:draw(x, y)
  local scissorX, scissorY, scissorWidth, scissorHeight = love.graphics.getScissor()
  love.graphics.intersectScissor(x + self.x, y + self.y, self.width, self.height)

  if self.backgroundColor then
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle("fill", x + self.x, y + self.y, self.width, self.height)
  end

  local child = self.children[1]

  if child then
    child:draw(x + self.x, y + self.y)
  end

  love.graphics.setScissor(scissorX, scissorY, scissorWidth, scissorHeight)
end

return ScrollWidget
