local UserWidget = {}
UserWidget.__index = UserWidget

function UserWidget.new()
  local widget = setmetatable({}, UserWidget)
  widget:init()
  return widget
end

function UserWidget:init()
  self.targetWidth, self.targetHeight = 0, 0

  self.x, self.y = 0, 0
  self.width, self.height = 0, 0

  self.dirty = false
  self.callbacks = {}
end

function UserWidget:destroy()
  if self.parent then
    self.parent:removeChild(self)
  end
end

function UserWidget:isDirty()
  return self.dirty
end

function UserWidget:setDirty(dirty)
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

function UserWidget:getTargetDimensions()
  return self.targetWidth, self.targetHeight
end

function UserWidget:getBounds()
  return self.x, self.y, self.width, self.height
end

function UserWidget:setBounds(x, y, width, height)
  self.x, self.y = x, y
  self.width, self.height = width, height
end

function UserWidget:draw(x, y)
  if self.callbacks.draw then
    self.callbacks.draw(x, y)
  end
end

function UserWidget:getCallback(name)
  return self.callbacks[name]
end

function UserWidget:setCallback(name, callback)
  self.callbacks[name] = callback
end

function UserWidget:mousepressed(x, y, button, istouch)
  if self.callbacks.mousepressed then
    return self.callbacks.mousepressed(x, y, button, istouch)
  end

  return false
end

return UserWidget
