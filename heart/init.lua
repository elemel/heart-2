local Game = require("heart.Game")
local Entity = require("heart.Entity")

return {
  newEntity = Entity.new,
  newGame = Game.new,
}
