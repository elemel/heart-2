local common = require("guilt.utils")

local ColumnWidget = {}
ColumnWidget.__index = ColumnWidget

function ColumnWidget.new()
  local widget = setmetatable({}, ColumnWidget)
  widget:init()
  return widget
end

function ColumnWidget:init()
  self.x, self.y = 0, 0
  self.width, self.height = 0, 0

  self.children = {}
  self.childWidths, self.childHeights = {}, {}

  self.dirty = false
end

function ColumnWidget:destroy()
  if self.parent then
    self.parent:removeChild(self)
  end
end

function ColumnWidget:getBounds()
  return self.x, self.y, self.width, self.height
end

function ColumnWidget:isDirty()
  return self.dirty
end

function ColumnWidget:setDirty(dirty)
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

function ColumnWidget:addChild(child)
  table.insert(self.children, child)
  table.insert(self.childWidths, 0)
  table.insert(self.childHeights, 0)
end

function ColumnWidget:removeChild(child)
  local i = common.removeArrayValue(self.children, child)

  if i then
    table.remove(self.childWidths, i)
    table.remove(self.childHeights, i)
  end
end

function ColumnWidget:clearChildren()
  self.children = {}
  self.childWidths, self.childHeights = {}, {}

  self.dirty = true
end

function ColumnWidget:getBackgroundColor()
  return self.backgroundColor
end

function ColumnWidget:setBackgroundColor(color)
  self.backgroundColor = color
end

function ColumnWidget:measure()
  local contentWidth, contentHeight = 0, 0
  local widths, heights = self.childWidths, self.childHeights

  for i, child in ipairs(self.children) do
    widths[i], heights[i] = child:measure()

    contentWidth = math.max(contentWidth, widths[i])
    contentHeight = contentHeight + heights[i]
  end

  return contentWidth, contentHeight
end

function ColumnWidget:arrange(x, y, width, height)
  self.x, self.y = x, y
  self.width, self.height = width, height

  local widths, heights = self.childWidths, self.childHeights
  local childY = 0

  for i, child in ipairs(self.children) do
    child:arrange(0, childY, width, heights[i])
    childY = childY + heights[i]
  end

  self.dirty = false
end

function ColumnWidget:draw(x, y)
  if self.backgroundColor then
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle("fill", x + self.x, y + self.y, self.width, self.height)
  end

  for i, child in ipairs(self.children) do
    child:draw(x + self.x, y + self.y)
  end
end

function ColumnWidget:mousepressed(x, y, button, istouch)
  local localX, localY = x - self.x, y - self.y

  for i, child in ipairs(self.children) do
    local childX, childY, childWidth, childHeight = child:getBounds()

    if childX <= localX and localX < childX + childWidth and
        childY <= localY and localY < childY + childHeight then
      if child:mousepressed(localX, localY, button, istouch) then
        return true
      end
    end
  end

  return false
end

return ColumnWidget
