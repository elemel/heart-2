local Gui = {}
Gui.__index = Gui

function Gui.new()
  local gui = setmetatable({}, Gui)
  gui:init()
  return gui
end

function Gui:init()
  self.scale = 1
  self.fontCache = {}
  self.controllers = {}
end

function Gui:getScale()
  return self.scale
end

function Gui:setScale(scale)
  self.scale = scale
end

function Gui:getFont(size)
  local font = self.fontCache[size]

  if not font then
    font = love.graphics.newFont(size)
    self.fontCache[size] = font
  end

  return font
end

function Gui:getRootWidget()
  return self.rootWidget
end

function Gui:setRootWidget(widget)
  self.rootWidget = widget
end

function Gui:addController(controller)
  table.insert(self.controllers, controller)
end

function Gui:removeController(controller)
  for i = #self.controllers, 1, -1 do
    if self.controllers[i] == controller then
      table.remove(self.controllers, i)
      break
    end
  end
end

function Gui:keypressed(key, scancode, isrepeat)
  for i = #self.controllers, 1, -1 do
    if self.controllers[i].keypressed and
        self.controllers[i]:keypressed(key, scancode, isrepeat) then

      return true
    end
  end

  return false
end

function Gui:mousepressed(x, y, button, istouch)
  for i = #self.controllers, 1, -1 do
    if self.controllers[i].mousepressed and
        self.controllers[i]:mousepressed(x, y, button, istouch) then

      return true
    end
  end

  return false
end

function Gui:textinput(text)
  for i = #self.controllers, 1, -1 do
    if self.controllers[i].textinput and
        self.controllers[i]:textinput(text) then

      return true
    end
  end

  return false
end

return Gui
