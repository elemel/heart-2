local heart = require("heart")
local jsua = require("jsua")

function love.load()
  love.window.setMode(800, 600, {
    fullscreentype = "desktop",
    resizable = true,
    highdpi = true,
  })

  love.physics.setMeter(1)

  game = heart.newGame({
    systems = {
      {
        systemType = "scripting",
      },

      {
        systemType = "physics",
      },

      {
        systemType = "animation",
      },

      {
        systemType = "graphics",
      },
    },

    entities = {
      {
        name = "ground",

        components = {
          {
            componentType = "bone",
          },

          {
            componentType = "body",
          },

          {
            componentType = "rectangleFixture",
            width = 10,
            angle = 0.1,
          },
        },
      },

      {
        name = "car",

        components = {
          {
            componentType = "bone",

            position = {
              x = 0,
              y = 4,
            },
          },

          {
            componentType = "body",
            bodyType = "dynamic",
          },

          {
            componentType = "rectangleFixture",
            width = 2,
            height = 0.5,
          },

          {
            componentType = "sprite",
            image = "resources/hull.png",
          },

          {
            componentType = "script",
          },
        },

        children = {
          {
            name = "frontWheel",

            components = {
              {
                componentType = "bone",

                position = {
                  x = 1,
                  y = 0,
                },
              },

              {
                componentType = "body",
                bodyType = "dynamic",
              },

              {
                componentType = "circleFixture",
                radius = 0.5,
              },

              {
                componentType = "revoluteJoint",
              },

              {
                componentType = "sprite",
                image = "resources/wheel.png",
              },
            },
          },

          {
            name = "rearWheel",

            components = {
              {
                componentType = "bone",

                position = {
                  x = -1,
                  y = 0,
                },
              },

              {
                componentType = "body",
                bodyType = "dynamic",
              },

              {
                componentType = "circleFixture",
                radius = 0.5,
              },

              {
                componentType = "revoluteJoint",
              },

              {
                componentType = "sprite",
                image = "resources/wheel.png",
              },
            },
          },
        },
      },
    },
  })

  -- print(jsua.write(game:getConfig()))
end

function love.update(dt)
  game:update(dt)
end

function love.draw()
  game:draw()
end
