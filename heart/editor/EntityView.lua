local BodyComponentView = require("heart.editor.BodyComponentView")
local BoneComponentView = require("heart.editor.BoneComponentView")
local guilt = require("guilt")

local EntityView = {}
EntityView.__index = EntityView

function EntityView.new(entity, parentWidget)
  local view = setmetatable({}, EntityView)
  view:init(entity, parentWidget)
  return view
end

function EntityView:init(entity, parentWidget)
  self.entity = assert(entity)

  self.widget = guilt.newColumnWidget()
  self.widget:setBackgroundColor({127, 127, 0, 127})
  parentWidget:setChild(3, 1, self.widget)

  if entity:getComponent("bone") then
    local boneComponent = entity:getComponent("bone")
    self.boneComponentView = BoneComponentView.new(boneComponent, self.widget)
  end

  if entity:getComponent("body") then
    local bodyComponent = entity:getComponent("body")
    self.bodyComponentView = BodyComponentView.new(bodyComponent, self.widget)
  end
end

function EntityView:destroy()
  if self.widget then
    self.widget:destroy()
    self.widget = nil
  end
end

function EntityView:update(dt)
  if self.bodyComponentView then
    self.bodyComponentView:update(dt)
  end

  if self.boneComponentView then
    self.boneComponentView:update(dt)
  end
end

return EntityView
