local guilt = require("guilt")
local EditTextController = require("heart.editor.EditTextController")

local BodyComponentView = {}
BodyComponentView.__index = BodyComponentView

function BodyComponentView.new(editor, parentWidget)
  local view = setmetatable({}, BodyComponentView)
  view:init(editor, parentWidget)
  return view
end

function BodyComponentView:init(editor, parentWidget)
  self.editor = assert(editor)

  self.widget = guilt.newBorderWidget(editor.gui, parentWidget, {
    border = 12,
  })

  local columnWidget = guilt.newColumnWidget(editor.gui, self.widget, {})

  guilt.newTextWidget(editor.gui, columnWidget, {
    text = "bodyComponent",
    alignmentX = 0,
  })

  self.propertyWidgets = {}

  for i, name in ipairs({"x", "y", "angle", "velocityX", "velocityY", "angularVelocity"}) do
    self.propertyWidgets[name] = guilt.newTextWidget(editor.gui, columnWidget, {
      alignmentX = 0,
    })
  end

  self.propertyWidgets.x:setCallback("mousepressed", function(x, y, button, istouch)
    EditTextController.new(self.propertyWidgets.x)
    return true
  end)
end

function BodyComponentView:update(dt)
  local entity = next(self.editor:getSelection())
  local component = entity and entity:getComponent("body")

  if self.editor.running or component ~= self.component then
    self.component = component

    if not self.component then
      for i, name in ipairs({"x", "y", "angle", "velocityX", "velocityY", "angularVelocity"}) do
        self.propertyWidgets[name]:setText(name .. " = ")
      end

      return
    end

    local body = component:getBody()
    local x, y = body:getPosition()
    local angle = body:getAngle()
    local velocityX, velocityY = body:getLinearVelocity()
    local angularVelocity = body:getAngularVelocity()

    self.propertyWidgets.x:setText(string.format("x = %.3f", x + 1e-6))
    self.propertyWidgets.y:setText(string.format("y = %.3f", y + 1e-6))
    self.propertyWidgets.angle:setText(string.format("angle = %.3f", angle + 1e-6))
    self.propertyWidgets.velocityX:setText(string.format("velocityX = %.3f", velocityX + 1e-6))
    self.propertyWidgets.velocityY:setText(string.format("velocityY = %.3f", velocityY + 1e-6))
    self.propertyWidgets.angularVelocity:setText(string.format("angularVelocity = %.3f", angularVelocity + 1e-6))
  end
end

return BodyComponentView
