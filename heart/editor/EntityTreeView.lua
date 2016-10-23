local guilt = require("guilt")
local EntityView = require("heart.editor.EntityView")

local EntityTreeView = {}
EntityTreeView.__index = EntityTreeView

function EntityTreeView.new(editor, parentWidget)
  local view = setmetatable({}, EntityTreeView)
  view:init(editor, parentWidget)
  return view
end

function EntityTreeView:init(editor, parentWidget)
  self.editor = assert(editor)
  self.game = assert(editor.game)
  self.parentWidget = assert(parentWidget)

  self.widget = guilt.newListWidget(self.editor.gui, self.parentWidget, {
    direction = "down",
  })

  for i, entity in ipairs(self.game.entities) do
    local textWidget = guilt.newTextWidget(self.editor.gui, self.widget, {
      text = entity:getUuid(),
      alignmentX = 0,
    })

    textWidget.callbacks.mousepressed = function(x, y, button, istouch)
      self.editor:deselectAll()
      self.editor:select(entity)
      return true
    end
  end
end

function EntityTreeView:update(dt)
end

return EntityTreeView
