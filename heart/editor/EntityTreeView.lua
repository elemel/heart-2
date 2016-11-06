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

  self.widget = guilt.newScrollWidget(editor.gui, parentWidget, {
    minWidth = 200, maxWidth = 200,
  })

  local borderWidget = guilt.newBorderWidget(editor.gui, self.widget, {
    border = 6,
  })

  local columnWidget = guilt.newColumnWidget(self.editor.gui, borderWidget, {})

  for i, entity in ipairs(self.game.entities) do
    local textWidget = guilt.newTextWidget(self.editor.gui, columnWidget, {
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
