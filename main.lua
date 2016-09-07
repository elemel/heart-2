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
        name = "ground",

        components = {
          {
            name = "transform",
          },

          {
            name = "body",
          },

          {
            name = "circleFixture",
            radius = 2,
          },

          {
            name = "sprite",
            image = "wheel.png",
          },
        },
      },

      {
        name = "car",

        children = {
          {
            name = "frontWheel",

            components = {
              {
                name = "transform",
                x = 1,
                y = 4,
              },

              {
                name = "body",
                type = "dynamic",
              },

              {
                name = "circleFixture",
                radius = 0.5,
              },

              {
                name = "sprite",
                image = "wheel.png",
              },
            },
          },

          {
            name = "rearWheel",

            components = {
              {
                name = "transform",
                x = -1,
                y = 4,
              },

              {
                name = "body",
                type = "dynamic",
              },

              {
                name = "circleFixture",
                radius = 0.5,
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
