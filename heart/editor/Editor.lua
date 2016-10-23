local guilt = require("guilt")
local EntityTreeView = require("heart.editor.EntityTreeView")
local EntityView = require("heart.editor.EntityView")
local DefaultController = require("heart.editor.DefaultController")

local Editor = {}
Editor.__index = Editor

function Editor.new(game)
  local editor = setmetatable({}, Editor)
  editor:init(game)
  return editor
end

function Editor:init(game)
  self.game = assert(game)
  self.selection = {}
  self.font = love.graphics.newFont(24)
  self.gui = guilt.newGui()
  self.gui:setFont(self.font)

  local rootWidget = guilt.newListWidget(self.gui, nil, {
    direction = "right",
  })

  self.gui:setRootWidget(rootWidget)

  local entityTreeScrollWidget = guilt.newScrollWidget(self.gui, self.gui.rootWidget, {})
  self.entityTreeView = EntityTreeView.new(self, entityTreeScrollWidget)

  self.gameWidget = guilt.newUserWidget(self.gui, self.gui.rootWidget, {
    weight = 1,
  })

  self.gameWidget:setCallback("draw", function(x, y)
    local viewportX, viewportY, viewportWidth, viewportHeight = self.gameWidget:getBounds()
    game:setViewport(x + viewportX, y + viewportY, viewportWidth, viewportHeight)
    game:draw()
  end)

  self.entityView = EntityView.new(self, self.gui.rootWidget)

  DefaultController.new(self.gui)
end

function Editor:destroy()
end

function Editor:select(obj)
  self.selection[obj] = true
end

function Editor:deselect(obj)
  self.selection[obj] = nil
end

function Editor:deselectAll()
  self.selection = {}
end

function Editor:isSelected(obj)
  return self.selection[obj] ~= nil
end

function Editor:getSelection()
  return self.selection
end

function Editor:update(dt)
  self.game:update(dt)

  self.entityTreeView:update(dt)
  self.entityView:update(dt)

  local width, height = love.graphics.getDimensions()
  self.gui.rootWidget:measure()
  self.gui.rootWidget:arrange(0, 0, width, height)
end

function Editor:draw()
  self.gui.rootWidget:draw(0, 0)
end

return Editor
