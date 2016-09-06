local Game = require "heart.Game"

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

      {
        name = "graphics",
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
                x = -2,
              },

              {
                name = "body",
              },

              {
                name = "sprite",
                image = "wheel.png",
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
