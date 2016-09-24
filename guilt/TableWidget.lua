local common = require("guilt.utils")

local TableWidget = {}
TableWidget.__index = TableWidget

function TableWidget.new(columnCount, rowCount)
  local widget = setmetatable({}, TableWidget)
  widget:init(columnCount, rowCount)
  return widget
end

function TableWidget:init(columnCount, rowCount)
  self.x, self.y = 0, 0
  self.width, self.height = 0, 0
  self.columnCount, self.rowCount = columnCount or 1, rowCount or 1
  self.children = {}
  self.columnWidths, self.rowHeights = {}, {}
  self.contentWidth, self.contentHeight = 0, 0
  self.columnWeights, self.rowWeights = {}, {}
  self.normalizedColumnWeights, self.normalizedRowWeights = {}, {}
  self.dirty = false
  self.weightsDirty = false
end

function TableWidget:destroy()
end

function TableWidget:getBounds()
  return self.x, self.y, self.width, self.height
end

function TableWidget:isDirty()
  return self.dirty
end

function TableWidget:setDirty(dirty)
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

function TableWidget:getBackgroundColor()
  return self.backgroundColor
end

function TableWidget:setBackgroundColor(color)
  self.backgroundColor = color
end

function TableWidget:getColumnCount()
  return self.columnCount
end

function TableWidget:setColumnCount(count)
  self.columnCount = count
  self:setDirty(true)
  self.weightsDirty = true
end

function TableWidget:getRowCount()
  return self.rowCount
end

function TableWidget:setRowCount(count)
  self.rowCount = count
  self:setDirty(true)
  self.weightsDirty = true
end

function TableWidget:getColumnWeight(i)
  return self.columnWeights[i]
end

function TableWidget:setColumnWeight(i, weight)
  self.columnWeights[i] = weight
  self.weightsDirty = true
end

function TableWidget:getRowWeight(i)
  return self.rowWeights[i]
end

function TableWidget:setRowWeight(i, weight)
  self.rowWeights[i] = weight
  self.weightsDirty = true
end

function TableWidget:getChild(columnIndex, rowIndex)
  return common.get2(self.children, columnIndex, rowIndex)
end

function TableWidget:setChild(columnIndex, rowIndex, child)
  common.set2(self.children, columnIndex, rowIndex, child)
  self:setDirty(true)
end

function TableWidget:measure()
  for i = 1, self.columnCount do
    self.columnWidths[i] = 0
  end

  for i = 1, self.rowCount do
    self.rowHeights[i] = 0
  end

  for i = 1, self.columnCount do
    for j = 1, self.rowCount do
      local child = common.get2(self.children, i, j)

      if child then
        local childWidth, childHeight = child:measure()

        self.columnWidths[i] = math.max(self.columnWidths[i], childWidth)
        self.rowHeights[j] = math.max(self.rowHeights[j], childHeight)
      end
    end
  end

  self.contentWidth, self.contentHeight = 0, 0

  for i = 1, self.columnCount do
    self.contentWidth = self.contentWidth + self.columnWidths[i]
  end

  for i = 1, self.rowCount do
    self.contentHeight = self.contentHeight + self.rowHeights[i]
  end

  return self.contentWidth, self.contentHeight
end

function TableWidget:arrange(x, y, width, height)
  self.x, self.y = x, y
  self.width, self.height = width, height

  self:normalizeWeights()

  local extraWidth = width - self.contentWidth
  local extraHeight = height - self.contentHeight

  for i = 1, self.columnCount do
    local weight = self.normalizedColumnWeights[i] or 0
    self.columnWidths[i] = self.columnWidths[i] + weight * extraWidth
  end

  for i = 1, self.rowCount do
    local weight = self.normalizedRowWeights[i] or 0
    self.rowHeights[i] = self.rowHeights[i] + weight * extraHeight
  end

  local childX = 0

  for i = 1, self.columnCount do
    local childY = 0

    for j = 1, self.rowCount do
      local child = common.get2(self.children, i, j)

      if child then
        child:arrange(childX, childY, self.columnWidths[i], self.rowHeights[j])
      end

      childY = childY + self.rowHeights[j]
    end

    childX = childX + self.columnWidths[i]
  end

  self.dirty = false
end

function TableWidget:draw(x, y)
  if self.backgroundColor then
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle("fill", x + self.x, y + self.y, self.width, self.height)
  end

  for i, column in pairs(self.children) do
    for j, child in pairs(column) do
      child:draw(x + self.x, y + self.y)
    end
  end
end

function TableWidget:mousepressed(x, y, button, istouch)
  local localX, localY = x - self.x, y - self.y

  for i, column in pairs(self.children) do
    for j, child in pairs(column) do
      local childX, childY, childWidth, childHeight = child:getBounds()

      if childX <= localX and localX < childX + childWidth and
          childY <= localY and localY < childY + childHeight then
        if child:mousepressed(localX, localY, button, istouch) then
          return true
        end
      end
    end
  end

  return false
end

function TableWidget:normalizeWeights()
  if self.weightsDirty then
    self:normalizeWeights2(self.columnWeights, self.normalizedColumnWeights, self.columnCount)
    self:normalizeWeights2(self.rowWeights, self.normalizedRowWeights, self.rowCount)
    self.weightsDirty = false
  end
end

function TableWidget:normalizeWeights2(source, target, count)
  local totalWeight = 0

  for i = 1, count do
    totalWeight = totalWeight + math.max(source[i] or 0, 0)
  end

  local offset = 0
  local scale = 1

  if totalWeight < 1 then
    offset = (1 - totalWeight) / count
  else
    scale = 1 / totalWeight
  end

  for i = 1, count do
    target[i] = offset + scale * math.max(source[i] or 0, 0)
  end
end

return TableWidget
