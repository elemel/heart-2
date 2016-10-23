local UserWidget = {}
UserWidget.__index = UserWidget

function UserWidget.new(gui, parent, config)
  local widget = setmetatable({}, UserWidget)
  widget:init(gui, parent, config)
  return widget
end

function UserWidget:init(gui, parent, config)
  self.gui = assert(gui)
  self:setParent(parent)

  self.weight = config.weight or 0

  self.x, self.y = 0, 0
  self.width, self.height = 0, 0
  self.measuredWidth, self.measuredHeight = 0, 0
  self.normalizedWeight = 0

  self.children = {}
  self.callbacks = {}
end

function UserWidget:destroy()
  self:setParent(nil)
  self.gui = nil
end

function UserWidget:getParent()
  return self.parent
end

function UserWidget:setParent(parent)
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

function UserWidget:addChild(child)
  table.insert(self.children, child)
end

function UserWidget:removeChild(child)
  for i = #self.children, 1, -1 do
    local sibling = self.children[i]

    if sibling == child then
      table.remove(self.children, i)
      break
    end
  end
end

function UserWidget:getBounds()
  return self.x, self.y, self.width, self.height
end

function UserWidget:getWeight()
  return self.weight
end

function UserWidget:setWeight(weight)
  self.weight = weight
end

function UserWidget:getCallback(name)
  return self.callbacks[name]
end

function UserWidget:setCallback(name, callback)
  self.callbacks[name] = callback
end

function UserWidget:measure()
  return self.measuredWidth, self.measuredHeight
end

function UserWidget:arrange(x, y, width, height)
  self.x, self.y = x, y
  self.width, self.height = width, height
end

function UserWidget:draw(x, y)
  local scissorX, scissorY, scissorWidth, scissorHeight = love.graphics.getScissor()
  love.graphics.intersectScissor(x + self.x, y + self.y, self.width, self.height)

  if self.callbacks.draw then
    self.callbacks.draw(x, y)
  end

  love.graphics.setScissor(scissorX, scissorY, scissorWidth, scissorHeight)
end

return UserWidget
