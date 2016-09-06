local Game = require "Game"

function love.load()
  love.window.setMode(800, 600, {
    fullscreentype = "desktop",
    resizable = true,
  })

  game = Game.new()

  game:load({
    systems = {
      {
        name = "transform",
      },

      {
        name = "physics",
      },
    },

    entities = {
      {
        name = "car",

        children = {
          {
            components = {
              {
                name = "transform",
              },

              {
                name = "body",
              },
            },
          },
        },
      },
    },
  })
end

function love.update(dt)
  game:update(dt)
end

function love.draw()
  game:draw()
end
