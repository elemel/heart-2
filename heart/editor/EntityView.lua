local BodyComponentView = require("heart.editor.BodyComponentView")
local BoneComponentView = require("heart.editor.BoneComponentView")
local guilt = require("guilt")

local EntityView = {}
EntityView.__index = EntityView

function EntityView.new(editor, parentWidget)
  local view = setmetatable({}, EntityView)
  view:init(editor, parentWidget)
  return view
end

function EntityView:init(editor, parentWidget)
  self.editor = assert(editor)

  self.widget = guilt.newScrollWidget(editor.gui, parentWidget, {
    minWidth = 200, maxWidth = 200,
  })

  local columnWidget = guilt.newColumnWidget(editor.gui, self.widget, {})

  local borderWidget = guilt.newBorderWidget(editor.gui, columnWidget, {
    border = 6,
  })

  self.entityNameWidget = guilt.newTextWidget(editor.gui, borderWidget, {
    alignmentX = 0,
  })

  self.boneComponentView = BoneComponentView.new(editor, columnWidget)
  self.bodyComponentView = BodyComponentView.new(editor, columnWidget)
end

function EntityView:destroy()
  self.bodyComponentView:destroy()
  self.boneComponentView:destroy()

  if self.widget then
    self.widget:destroy()
    self.widget = nil
  end

  self.editor = nil
end

function EntityView:update(dt)
  local entity = next(self.editor:getSelection())
  self.entityNameWidget:setText(entity and "uuid = " .. entity:getUuid() or "")
  self.bodyComponentView:update(dt)
  self.boneComponentView:update(dt)
end

return EntityView
