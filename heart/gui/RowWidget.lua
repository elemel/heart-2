local common = require("heart.common")

local RowWidget = {}
RowWidget.__index = RowWidget

function RowWidget.new()
  local widget = setmetatable({}, RowWidget)
  widget:init()
  return widget
end

function RowWidget:init()
  self.x, self.y = 0, 0
  self.width, self.height = 0, 0

  self.children = {}
  self.childWidths, self.childHeights = {}, {}

  self.dirty = false
end

function RowWidget:getBounds()
  return self.x, self.y, self.width, self.height
end

function RowWidget:isDirty()
  return self.dirty
end

function RowWidget:setDirty(dirty)
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

function RowWidget:addChild(child)
  table.insert(self.children, child)
  table.insert(self.childWidths, 0)
  table.insert(self.childHeights, 0)
end

function RowWidget:removeChild(child)
  local i = common.removeArrayValue(self.children, child)

  if i then
    table.remove(self.childWidths, i)
    table.remove(self.childHeights, i)
  end
end

function RowWidget:getBackgroundColor()
  return self.backgroundColor
end

function RowWidget:setBackgroundColor(color)
  self.backgroundColor = color
end

function RowWidget:measure()
  local contentWidth, contentHeight = 0, 0
  local widths, heights = self.childWidths, self.childHeights

  for i, child in ipairs(self.children) do
    widths[i], heights[i] = child:measure()

    contentWidth = contentWidth + widths[i]
    contentHeight = math.max(contentHeight, heights[i])
  end

  return contentWidth, contentHeight
end

function RowWidget:arrange(x, y, width, height)
  self.x, self.y = x, y
  self.width, self.height = width, height

  local widths, heights = self.childWidths, self.childHeights
  local childX = 0

  for i, child in ipairs(self.children) do
    child:arrange(childX, 0, widths[i], height)
    childX = childX + widths[i]
  end

  self.dirty = false
end

function RowWidget:draw(x, y)
  if self.backgroundColor then
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle("fill", x + self.x, y + self.y, self.width, self.height)
  end

  for i, child in ipairs(self.children) do
    child:draw(x + self.x, y + self.y)
  end
end

function RowWidget:mousepressed(x, y, button, istouch)
  local localX, localY = x - self.x, y - self.y

  for i, child in ipairs(self.children) do
    local childX, childY, childWidth, childHeight = child:getBounds()

    if childX <= localX and localX < childX + childWidth and
        childY <= localY and localY < childY + childHeight then
      if child:mousepressed(localX, localY) then
        return true
      end
    end
  end

  return false
end

return RowWidget
