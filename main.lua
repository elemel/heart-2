local heart = require("heart")

function love.load()
  love.window.setMode(800, 600, {
    fullscreentype = "desktop",
    resizable = true,
    highdpi = true,
  })

  love.physics.setMeter(1)

  game = heart.newGame()

  game:load({
    systems = {
      {
        type = "animation",
      },

      {
        type = "physics",
      },

      {
        type = "graphics",
      },
    },

    entities = {
      {
        name = "ground",

        components = {
          {
            type = "transform",
          },

          {
            type = "body",
          },

          {
            type = "rectangleFixture",
            width = 10,
            angle = 0.1,
          },
        },
      },

      {
        name = "car",

        components = {
          {
            type = "transform",
            x = 0,
            y = 4,
          },

          {
            type = "body",
            bodyType = "dynamic",
          },

          {
            type = "rectangleFixture",
            width = 2,
            height = 0.5,
          },

          {
            type = "sprite",
            image = "hull.png",
          },
        },

        children = {
          {
            name = "frontWheel",

            components = {
              {
                type = "transform",
                x = 1,
                y = 4,
              },

              {
                type = "body",
                bodyType = "dynamic",
              },

              {
                type = "circleFixture",
                radius = 0.5,
              },

              {
                type = "revoluteJoint",
              },

              {
                type = "sprite",
                image = "wheel.png",
              },
            },
          },

          {
            name = "rearWheel",

            components = {
              {
                type = "transform",
                x = -1,
                y = 4,
              },

              {
                type = "body",
                bodyType = "dynamic",
              },

              {
                type = "circleFixture",
                radius = 0.5,
              },

              {
                type = "revoluteJoint",
              },

              {
                type = "sprite",
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
