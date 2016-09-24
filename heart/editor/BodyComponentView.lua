local gui = require("heart.gui")

local BodyComponentView = {}
BodyComponentView.__index = BodyComponentView

function BodyComponentView.new(component, parentWidget)
  local view = setmetatable({}, BodyComponentView)
  view:init(component, parentWidget)
  return view
end

function BodyComponentView:init(component, parentWidget)
  self.component = component

  local tableWidget = gui.newTableWidget()
  parentWidget:addChild(tableWidget)

  local propertyListWidget = gui.newColumnWidget()
  propertyListWidget:setBackgroundColor({127, 0, 127, 127})
  parentWidget:addChild(propertyListWidget)

  local titleWidget = gui.newTextWidget()
  titleWidget:setText("body")
  titleWidget:setFont(love.graphics:getFont())
  titleWidget:setColor({255, 255, 255, 255})
  propertyListWidget:addChild(titleWidget)

  self.propertyValueWidgets = {}

  tableWidget:setColumnCount(2)
  tableWidget:setRowCount(3)

  for i, name in ipairs({"x", "y", "angle"}) do
    local nameWidget = gui.newTextWidget()
    nameWidget:setText(name)
    nameWidget:setFont(love.graphics:getFont())
    nameWidget:setColor({255, 255, 255, 255})
    tableWidget:setChild(1, i, nameWidget)

    local valueWidget = gui.newTextWidget()
    valueWidget:setFont(love.graphics:getFont())
    valueWidget:setColor({255, 255, 255, 255})
    tableWidget:setChild(2, i, valueWidget)

    self.propertyValueWidgets[name] = valueWidget
  end
end

function BodyComponentView:update(dt)
  local x, y = self.component:getBody():getPosition()
  local angle = self.component:getBody():getAngle()

  self.propertyValueWidgets.x:setText(string.format("%g", x))
  self.propertyValueWidgets.y:setText(string.format("%g", y))
  self.propertyValueWidgets.angle:setText(string.format("%g", angle))
end

return BodyComponentView
