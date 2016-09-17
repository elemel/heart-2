local BodyComponentView = require("heart.editor.BodyComponentView")
local BoneComponentView = require("heart.editor.BoneComponentView")
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

  self.rootWidget = gui.newBorderWidget()
  self.rootWidget:setBackgroundColor({127, 0, 0, 127})

  local systemListWidget = gui.newRowWidget()
  systemListWidget:setBackgroundColor({0, 127, 0, 127})
  self.rootWidget:setChild("top", systemListWidget)

  for i, system in ipairs(game.systems) do
    local textWidget = gui.newTextWidget()
    textWidget:setText(system:getSystemType())
    textWidget:setFont(love.graphics:getFont())
    textWidget:setColor({255, 255, 255, 255})
    systemListWidget:addChild(textWidget)
  end

  self.entityListWidget = gui.newColumnWidget()
  self.entityListWidget:setBackgroundColor({0, 127, 127, 127})
  self.rootWidget:setChild("left", self.entityListWidget)

  self.componentListWidget = gui.newColumnWidget()
  self.componentListWidget:setBackgroundColor({127, 127, 0, 127})
  self.rootWidget:setChild("right", self.componentListWidget)

  for i, entity in ipairs(game.entities) do
    local textWidget = gui.newTextWidget()
    textWidget:setText(entity:getUuid())
    textWidget:setFont(love.graphics:getFont())
    textWidget:setColor({255, 255, 255, 255})
    self.entityListWidget:addChild(textWidget)

    textWidget.callbacks.mousepressed = function(x, y, button, istouch)
      self.componentListWidget:clearChildren()
      self.bodyComponentView = nil
      self.boneComponentView = nil

      if entity:getComponent("bone") then
        local boneComponent = entity:getComponent("bone")
        self.boneComponentView = BoneComponentView.new(boneComponent, self.componentListWidget)
      end

      if entity:getComponent("body") then
        local bodyComponent = entity:getComponent("body")
        self.bodyComponentView = BodyComponentView.new(bodyComponent, self.componentListWidget)
      end

      return true
    end
  end
end

function Editor:destroy()
end

function Editor:update(dt)
  if self.bodyComponentView then
    self.bodyComponentView:update(dt)
  end

  if self.boneComponentView then
    self.boneComponentView:update(dt)
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
