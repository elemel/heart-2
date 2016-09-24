local guilt = require("guilt")

local BoneComponentView = {}
BoneComponentView.__index = BoneComponentView

function BoneComponentView.new(component, parentWidget)
  local view = setmetatable({}, BoneComponentView)
  view:init(component, parentWidget)
  return view
end

function BoneComponentView:init(component, parentWidget)
  self.component = component

  local propertyListWidget = guilt.newColumnWidget()
  propertyListWidget:setBackgroundColor({127, 0, 127, 127})
  parentWidget:addChild(propertyListWidget)

  local titleWidget = guilt.newTextWidget()
  titleWidget:setText("bone")
  titleWidget:setFont(love.graphics:getFont())
  titleWidget:setColor({255, 255, 255, 255})
  propertyListWidget:addChild(titleWidget)

  self.propertyValueWidgets = {}

  for i, name in ipairs({"x", "y", "angle"}) do
    local nameWidget = guilt.newTextWidget()
    nameWidget:setText(name)
    nameWidget:setFont(love.graphics:getFont())
    nameWidget:setColor({255, 255, 255, 255})
    propertyListWidget:addChild(nameWidget)

    local valueWidget = guilt.newTextWidget()
    valueWidget:setFont(love.graphics:getFont())
    valueWidget:setColor({255, 255, 255, 255})
    propertyListWidget:addChild(valueWidget)

    self.propertyValueWidgets[name] = valueWidget
  end
end

function BoneComponentView:update(dt)
  local x, y = self.component:getPosition()
  local angle = self.component:getAngle()

  self.propertyValueWidgets.x:setText(string.format("%g", x))
  self.propertyValueWidgets.y:setText(string.format("%g", y))
  self.propertyValueWidgets.angle:setText(string.format("%g", angle))
end

return BoneComponentView
