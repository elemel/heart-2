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
    minWidth = 400, maxWidth = 400,
  })

  local listWidget = guilt.newListWidget(editor.gui, self.widget, {
    direction = "down",
  })

  local borderWidget = guilt.newBorderWidget(editor.gui, listWidget, {
    border = 12,
  })

  self.entityNameWidget = guilt.newTextWidget(editor.gui, borderWidget, {
    alignmentX = 0,
  })

  self.boneComponentView = BoneComponentView.new(editor, listWidget)
  self.bodyComponentView = BodyComponentView.new(editor, listWidget)
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
