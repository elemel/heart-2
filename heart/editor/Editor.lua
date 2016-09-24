local EntityView = require("heart.editor.EntityView")
local EntityTreeView = require("heart.editor.EntityTreeView")
local gui = require("heart.gui")

local Editor = {}
Editor.__index = Editor

function Editor.new(game)
  local editor = setmetatable({}, Editor)
  editor:init(game)
  return editor
end

function Editor:init(game)
  self.game = assert(game)

  self.rootWidget = gui.newTableWidget(1, 3)
  self.rootWidget:setRowWeight(2, 1)
  self.rootWidget:setBackgroundColor({127, 0, 0, 127})

  local systemListWidget = gui.newRowWidget()
  systemListWidget:setBackgroundColor({0, 127, 0, 127})
  self.rootWidget:setChild(1, 1, systemListWidget)

  local horizontalWidget = gui.newTableWidget(3, 1)
  horizontalWidget:setColumnWeight(2, 1)
  self.rootWidget:setChild(1, 2, horizontalWidget)

  for i, system in ipairs(game.systems) do
    local textWidget = gui.newTextWidget()
    textWidget:setText(system:getSystemType())
    textWidget:setFont(love.graphics:getFont())
    textWidget:setColor({255, 255, 255, 255})

    local borderWidget = gui.newBorderWidget()
    borderWidget:setBorders(10)
    borderWidget:setChild(textWidget)
    systemListWidget:addChild(borderWidget)
  end

  self.entityTreeView = EntityTreeView.new(self, game, horizontalWidget, 1, 1)
end

function Editor:destroy()
end

function Editor:update(dt)
  if self.entityView then
    self.entityView:update(dt)
  end

  local width, height = love.graphics.getDimensions()

  self.rootWidget:measure()
  self.rootWidget:arrange(0, 0, width, height)
end

function Editor:draw()
  self.rootWidget:draw(0, 0)
end

function Editor:mousepressed(x, y, button, istouch)
  self.rootWidget:mousepressed(x, y, button, istouch)
end

return Editor
