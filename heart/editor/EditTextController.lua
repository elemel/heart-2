local utf8 = require("utf8")

local EditTextController = {}
EditTextController.__index = EditTextController

function EditTextController.new(widget)
  local controller = setmetatable({}, EditTextController)
  controller:init(widget)
  return controller
end

function EditTextController:init(widget)
  self.widget = assert(widget)
  self.gui = assert(widget:getGui())
  self.gui:addController(self)
end

function EditTextController:destroy()
  if self.gui then
    self.gui:removeController(self)
    self.gui = nil
  end
end

function EditTextController:keypressed(key, scancode, isrepeat)
  if scancode == "backspace" then
    local text = self.widget:getText()
    local offset = utf8.offset(text, -1)
 
    if offset then
      text = string.sub(text, 1, offset - 1)
      self.widget:setText(text)
    end
  end
end

function EditTextController:textinput(text)
  self.widget:setText(self.widget:getText() .. text)
end

return EditTextController
