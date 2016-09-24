local gui = require("heart.gui")
local EntityView = require("heart.editor.EntityView")

local EntityTreeView = {}
EntityTreeView.__index = EntityTreeView

function EntityTreeView.new(editor, game, parentWidget, columnIndex, rowIndex)
  local view = setmetatable({}, EntityTreeView)
  view:init(editor, game, parentWidget, columnIndex, rowIndex)
  return view
end

function EntityTreeView:init(editor, game, parentWidget, columnIndex, rowIndex)
  self.editor = assert(editor)
  self.game = assert(game)
  self.parentWidget = assert(parentWidget)

  self.widget = gui.newColumnWidget()
  self.widget:setBackgroundColor({0, 127, 127, 127})
  parentWidget:setChild(columnIndex, rowIndex, self.widget)

  for i, entity in ipairs(self.game.entities) do
    local textWidget = gui.newTextWidget()
    textWidget:setText(entity:getUuid())
    textWidget:setFont(love.graphics:getFont())
    textWidget:setColor({255, 255, 255, 255})
    self.widget:addChild(textWidget)

    textWidget.callbacks.mousepressed = function(x, y, button, istouch)
      if self.editor.entityView then
        self.editor.entityView:destroy()
        self.editor.entityView = nil
      end

      self.editor.entityView = EntityView.new(entity, self.parentWidget)
      return true
    end
  end
end

return EntityTreeView
