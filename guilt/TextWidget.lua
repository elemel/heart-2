local TextWidget = {}
TextWidget.__index = TextWidget

function TextWidget.new()
  local widget = setmetatable({}, TextWidget)
  widget:init()
  return widget
end

function TextWidget:init()
  self.x, self.y = 0, 0
  self.width, self.height = 0, 0

  self.alignmentX, self.alignmentY = 0, 0
  self.dirty = false
  self.callbacks = {}
end

function TextWidget:getBounds()
  return self.x, self.y, self.width, self.height
end

function TextWidget:isDirty()
  return self.dirty
end

function TextWidget:setDirty(dirty)
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

function TextWidget:getText()
  return self.text
end

function TextWidget:setText(text)
  if text ~= self.text then
    self.text = text
    self:setDirty(true)
  end
end

function TextWidget:getFont()
  return self.font
end 

function TextWidget:setFont(font)
  if font ~= self.font then
    self.font = font
    self:setDirty(true)
  end
end

function TextWidget:getAlignment()
  return self.alignmentX, self.alignmentY
end

function TextWidget:setAlignment(alignmentX, alignmentY)
  if alignmentX ~= self.alignmentX or alignmentY ~= self.alignmentY then
    self.alignmentX, self.alignmentY = alignmentX, alignmentY
    self:setDirty(true)
  end
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

function TextWidget:getTargetDimensions()
  if self.targetWidth and self.targetHeight then
    return self.targetWidth, self.targetHeight
  end

  local textWidth, textHeight = 0, 0

  if self.text and self.font then
    textWidth = self.font:getWidth(self.text)
  end

  if self.font then
    textHeight = self.font:getHeight()
  end

  return self.targetWidth or textWidth, self.targetHeight or textHeight
end

function TextWidget:setTargetDimensions(width, height)
  self.targetWidth, self.targetHeight = width, height
end

function TextWidget:setBounds(x, y, width, height)
  self.x, self.y = x, y
  self.width, self.height = width, height
  self.dirty = false
end

function TextWidget:draw(x, y)
  if self.backgroundColor then
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle("fill", x + self.x, y + self.y, self.width, self.height)
  end

  if self.text and self.font and self.color then
    love.graphics.setColor(self.color)
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, x + self.x, y + self.y)
  end
end

function TextWidget:mousepressed(x, y, button, istouch)
  if self.callbacks.mousepressed then
    return self.callbacks.mousepressed(x, y, button, istouch)
  end

  return false
end

function TextWidget:getCallback(name)
  return self.callbacks[name]
end

function TextWidget:setCallback(name, callback)
  self.callbacks[name] = callback
end

return TextWidget
