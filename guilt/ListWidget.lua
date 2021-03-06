local ColumnLayout = require("guilt.ColumnLayout")
local RowLayout = require("guilt.RowLayout")

local ListWidget = {}
ListWidget.__index = ListWidget

function ListWidget.newRow(gui, parent, config)
  local layout = RowLayout.new()
  local widget = setmetatable({}, ListWidget)
  widget:init(layout, gui, parent, config)
  return widget
end

function ListWidget.newColumn(gui, parent, config)
  local layout = ColumnLayout.new()
  local widget = setmetatable({}, ListWidget)
  widget:init(layout, gui, parent, config)
  return widget
end

function ListWidget:init(layout, gui, parent, config)
  self.layout = assert(layout)
  self.gui = assert(gui)
  self:setParent(parent)

  self.weight = config.weight or 0

  self.x, self.y = 0, 0
  self.width, self.height = 0, 0
  self.measuredWidth, self.measuredHeight = 0, 0
  self.normalizedWeight = 0, 0

  self.children = {}
  self.callbacks = {}
end

function ListWidget:destroy()
  for i = #self.children, 1, -1 do
    local child = self.children[i]
    child:destroy()
  end

  self:setParent(nil)
end

function ListWidget:getParent()
  return self.parent
end

function ListWidget:setParent(parent)
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

function ListWidget:addChild(child)
  table.insert(self.children, child)
end

function ListWidget:removeChild(child)
  for i = #self.children, 1, -1 do
    local sibling = self.children[i]

    if sibling == child then
      table.remove(self.children, i)
      break
    end
  end
end

function ListWidget:getBackgroundColor()
  return self.backgroundColor
end

function ListWidget:setBackgroundColor(color)
  self.backgroundColor = color
end

function ListWidget:getBounds()
  return self.x, self.y, self.width, self.height
end

function ListWidget:getCallback(name)
  return self.callbacks[name]
end

function ListWidget:setCallback(name, callback)
  self.callbacks[name] = callback
end

function ListWidget:measure()
  self.measuredWidth, self.measuredHeight = self.layout:measure(self)
  return self.measuredWidth, self.measuredHeight
end

function ListWidget:arrange(x, y, width, height)
  self.x, self.y = x, y
  self.width, self.height = width, height
  self:normalizeChildWeights()
  self.layout:arrange(self)
end

function ListWidget:draw(x, y)
  if self.backgroundColor then
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle("fill", x + self.x, y + self.y, self.width, self.height)
  end

  for i, child in ipairs(self.children) do
    child:draw(x + self.x, y + self.y)
  end
end

function ListWidget:normalizeChildWeights()
  local totalWeight = 0

  for i, child in ipairs(self.children) do
    totalWeight = totalWeight + child.weight
  end

  local offset = 0
  local scale = 1

  if totalWeight < 1 then
    offset = (1 - totalWeight) / #self.children
  else
    scale = 1 / totalWeight
  end

  for i, child in ipairs(self.children) do
    child.normalizedWeight = offset + scale * child.weight
  end
end

return ListWidget
