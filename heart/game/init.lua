local Game = require("heart.game.Game")
local Entity = require("heart.game.Entity")

return {
  newEntity = Entity.new,
  newGame = Game.new,
}
