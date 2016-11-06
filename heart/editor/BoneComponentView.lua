local guilt = require("guilt")
local utf8 = require("utf8")

local BoneComponentView = {}
BoneComponentView.__index = BoneComponentView

function BoneComponentView.new(editor, parentWidget)
  local view = setmetatable({}, BoneComponentView)
  view:init(editor, parentWidget)
  return view
end

function BoneComponentView:init(editor, parentWidget)
  self.editor = assert(editor)

  self.widget = guilt.newBorderWidget(editor.gui, parentWidget, {
    border = 12,
  })

  local columnWidget = guilt.newColumnWidget(editor.gui, self.widget, {})

  guilt.newTextWidget(editor.gui, columnWidget, {
    text = "boneComponent",
    alignmentX = 0,
  })

  self.propertyWidgets = {}

  for i, name in ipairs({"x", "y", "angle"}) do
    self.propertyWidgets[name] = guilt.newTextWidget(editor.gui, columnWidget, {
      alignmentX = 0,
    })
  end
end

function BoneComponentView:update(dt)
  local entity = next(self.editor:getSelection())
  local component = entity and entity:getComponent("bone")

  if not component then
    return
  end

  local x, y = component:getPosition()
  local angle = component:getAngle()

  self.propertyWidgets.x:setText(string.format("x = %.3f", x + 1e-6))
  self.propertyWidgets.y:setText(string.format("y = %.3f", y + 1e-6))
  self.propertyWidgets.angle:setText(string.format("angle = %.3f", angle + 1e-6))
end

return BoneComponentView
