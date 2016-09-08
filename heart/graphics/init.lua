local GraphicsSystem = require("heart.graphics.GraphicsSystem")
local SpriteComponent = require("heart.graphics.SpriteComponent")

return {
  newGraphicsSystem = GraphicsSystem.new,
  newSpriteComponent = SpriteComponent.new,
}
