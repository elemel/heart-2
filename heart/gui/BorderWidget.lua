local common = require("heart.common")

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

  self.children = {}
  self.childNames = {"top", "left", "center", "right", "bottom"}
  self.childWidths, self.childHeights = {}, {}

  for i, name in ipairs(self.childNames) do
    self.childWidths[name], self.childHeights[name] = 0
    self.childHeights[name] = 0
  end

  self.dirty = false
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

function BorderWidget:getChild(name)
  return self.children[name]
end

function BorderWidget:setChild(name, child)
  if self.children[name] ~= child then
    if child and child.parent then
      child.parent:removeChild(child)
    end 

    if self.children[name] then
      self:removeChild(self.children[name])
    end

    self.children[name] = child

    if child then
      child.parent = self
    end

    self:setDirty(true)
  end
end

function BorderWidget:removeChild(child)
  local name = common.removeValue(self.children, child)

  if name then
    self.childWidths[name], self.childHeights[name] = 0, 0
    self:setDirty(true)
  end
end

function BorderWidget:getBackgroundColor()
  return self.backgroundColor
end

function BorderWidget:setBackgroundColor(color)
  self.backgroundColor = color
end

function BorderWidget:measure()
  local contentWidth, contentHeight = 0, 0

  for i, name in ipairs(self.childNames) do
    local child = self.children[name]
    local width, height = 0, 0

    if child then
      width, height = child:measure()

      contentWidth = contentWidth + width
      contentHeight = contentHeight + height
    end

    self.childWidths[name], self.childHeights[name] = width, height
  end

  return contentWidth, contentHeight
end

function BorderWidget:arrange(x, y, width, height)
  self.x, self.y = x, y
  self.width, self.height = width, height

  local widths, heights = self.childWidths, self.childHeights

  local centerWidth = width - widths.left - widths.right
  local centerHeight = height - heights.top - heights.bottom

  if self.children.top then
    self.children.top:arrange(0, 0, width, heights.top)
  end

  if self.children.left then
    self.children.left:arrange(0, heights.top, widths.left, centerHeight)
  end

  if self.children.center then
    self.children.center:arrange(widths.left, heights.top,
      centerWidth, centerHeight)
  end

  if self.children.right then
    self.children.right:arrange(width - widths.right, heights.top,
      widths.right, centerHeight)
  end

  if self.children.bottom then
    self.children.top:arrange(0, height - heights.bottom,
      width, heights.bottom)
  end

  self.dirty = false
end

function BorderWidget:draw(x, y)
  if self.backgroundColor then
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle("fill", x + self.x, y + self.y, self.width, self.height)
  end

  for name, child in pairs(self.children) do
    child:draw(x + self.x, y + self.y)
  end
end

function BorderWidget:mousepressed(x, y, button, istouch)
  local localX, localY = x - self.x, y - self.y

  for name, child in pairs(self.children) do
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

return BorderWidget
