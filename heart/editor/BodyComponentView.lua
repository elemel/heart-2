local guilt = require("guilt")

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

  local listWidget = guilt.newListWidget(editor.gui, self.widget, {
    direction = "down",
  })

  guilt.newTextWidget(editor.gui, listWidget, {
    text = "bodyComponent",
    alignmentX = 0,
  })

  self.propertyWidgets = {}

  for i, name in ipairs({"x", "y", "angle", "velocityX", "velocityY", "angularVelocity"}) do
    self.propertyWidgets[name] = guilt.newTextWidget(editor.gui, listWidget, {
      alignmentX = 0,
    })
  end
end

function BodyComponentView:update(dt)
  local entity = next(self.editor:getSelection())
  local component = entity and entity:getComponent("body")

  if not component then
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

return BodyComponentView
