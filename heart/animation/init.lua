local AnimationSystem = require("heart.animation.AnimationSystem")
local TransformComponent = require("heart.animation.TransformComponent")

return {
  newAnimationSystem = AnimationSystem.new,
  newTransformComponent = TransformComponent.new,
}
