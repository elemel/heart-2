local ParentingComponent = require("heart.parenting.ParentingComponent")
local ParentingSystem = require("heart.parenting.ParentingSystem")

return {
  newParentingComponent = ParentingComponent.new,
  newParentingSystem = ParentingSystem.new,
}
