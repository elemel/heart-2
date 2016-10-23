local DefaultController = {}
DefaultController.__index = DefaultController

function DefaultController.new(gui)
  local controller = setmetatable({}, DefaultController)
  controller:init(gui)
  return controller
end

function DefaultController:init(gui)
  self.gui = assert(gui)
  self.gui:addController(self)
end

function DefaultController:destroy()
  if self.gui then
    self.gui:removeController(self)
    self.gui = nil
  end
end

function DefaultController:mousepressed(x, y, button, istouch)
  local widget = self.gui:getRootWidget()

  if not widget then
    return false
  end

  return self:mousepressed2(widget, x, y, button, istouch)
end

function DefaultController:mousepressed2(widget, x, y, button, istouch)
  if widget.x <= x and x < widget.x + widget.width and
      widget.y <= y and y < widget.y + widget.height then

    if widget.children then
      local localX, localY = x - widget.x, y - widget.y

      for i, child in ipairs(widget.children) do
        if self:mousepressed2(child, localX, localY, button, istouch) then
          return true
        end
      end
    end

    local callback = widget:getCallback("mousepressed")

    if callback and callback(x, y, button, istouch) then
      return true
    end
  end

  return false
end

return DefaultController
