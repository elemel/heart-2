local AnimationSystem = require("heart.animation.AnimationSystem")
local BoneComponent = require("heart.animation.BoneComponent")

return {
  newAnimationSystem = AnimationSystem.new,
  newBoneComponent = BoneComponent.new,
}
