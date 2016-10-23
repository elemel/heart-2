local Gui = {}
Gui.__index = Gui

function Gui.new()
  local gui = setmetatable({}, Gui)
  gui:init()
  return gui
end

function Gui:init()
  self.controllers = {}
end

function Gui:getFont(font)
  return self.font
end

function Gui:setFont(font)
  self.font = font
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

function Gui:mousepressed(x, y, button, istouch)
  for i = #self.controllers, 1, -1 do
    if self.controllers[i].mousepressed and
        self.controllers[i]:mousepressed(x, y, button, istouch) then

      return true
    end
  end

  return false
end

return Gui
