local utf8 = require("utf8")

local TextWidget = {}
TextWidget.__index = TextWidget

function TextWidget.new(gui, parent, config)
  local widget = setmetatable({}, TextWidget)
  widget:init(gui, parent, config)
  return widget
end

function TextWidget:init(gui, parent, config)
  self.gui = assert(gui)
  self:setParent(parent)

  self.text = config.text or ""
  self.color = config.color or {255, 255, 255, 255}
  self.backgroundColor = config.backgroundColor or nil
  self.weight = config.weight or 0
  self.fontSize = config.fontSize or 12

  self.alignmentX = config.alignmentX or 0.5
  self.alignmentY = config.alignmentY or 0.5

  self.x, self.y = 0, 0
  self.width, self.height = 0, 0
  self.measuredWidth, self.measuredHeight = 0, 0
  self.normalizedWeight = 0, 0

  self.selectionOffset = 2
  self.selectionLength = 1


  self.callbacks = {}
end

function TextWidget:destroy()
  self:setParent(nil)
  self.gui = nil
end

function TextWidget:getGui()
  return self.gui
end

function TextWidget:getParent()
  return self.parent
end

function TextWidget:setParent(parent)
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

function TextWidget:getText()
  return self.text
end

function TextWidget:setText(text)
  self.text = text
end

function TextWidget:getFontSize()
  return self.fontSize
end 

function TextWidget:setFontSize(size)
  self.fontSize = size
end

function TextWidget:getColor()
  return self.color
end

function TextWidget:setColor(color)
  self.color = color
end

function TextWidget:getBackgroundColor()
  return self.backgroundColor
end

function TextWidget:setBackgroundColor(color)
  self.backgroundColor = color
end

function TextWidget:getBounds()
  return self.x, self.y, self.width, self.height
end

function TextWidget:getWeight()
  return self.weight
end

function TextWidget:setWeight(weight)
  self.weight = weight
end

function TextWidget:getCallback(name)
  return self.callbacks[name]
end

function TextWidget:setCallback(name, callback)
  self.callbacks[name] = callback
end

function TextWidget:measure()
  local scale = self.gui:getScale()
  local font = self.gui:getFont(scale * self.fontSize)

  self.measuredWidth = font:getWidth(self.text)
  self.measuredHeight = font:getHeight()

  return self.measuredWidth, self.measuredHeight
end

function TextWidget:arrange(x, y, width, height)
  self.x, self.y = x, y
  self.width, self.height = width, height
end

function TextWidget:draw(x, y)
  if self.backgroundColor then
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle("fill", x + self.x, y + self.y, self.width, self.height)
  end

  if self.text and self.color then
    local scale = self.gui:getScale()
    local font = self.gui:getFont(scale * self.fontSize)

    local extraWidth = self.width - self.measuredWidth
    local extraHeight = self.height - self.measuredHeight

    local textX = math.floor(x + self.x + self.alignmentX * extraWidth + 0.5)
    local textY = math.floor(y + self.y + self.alignmentY * extraHeight + 0.5)

    love.graphics.setColor(self.color)
    love.graphics.setFont(font)
    love.graphics.print(self.text, textX, textY)
  end

  if self.selectionOffset and self.color then
    local scale = self.gui:getScale()
    local font = self.gui:getFont(scale * self.fontSize)

    local prefix = string.sub(self.text, 1, self.selectionOffset - 1)
    local prefixWidth = font:getWidth(prefix)
    local selectionHeight = font:getHeight()
    love.graphics.setColor(self.color)

    if self.selectionLength == 0 then
      love.graphics.line(x + self.x + prefixWidth, y + self.y,
        x + self.x + prefixWidth, y + self.y + selectionHeight)
    else
      local selection = string.sub(self.text, self.selectionOffset, self.selectionOffset + self.selectionLength - 1)
      local selectionWidth = font:getWidth(selection)
      love.graphics.rectangle("line", x + self.x + prefixWidth,
        y + self.y, selectionWidth, selectionHeight)
    end
  end
end

return TextWidget
