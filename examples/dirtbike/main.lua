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
        systemType = "parenting",
      },

      {
        systemType = "scripting",
      },

      {
        systemType = "physics",

        gravity = {
          x = 0,
          y = -10,
        },
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

            dimensions = {
              width = 10,
              height = 1,
            },

            angle = 0.1,
          },
        },
      },

      {
        uuid = "ed15bf2b-60ff-4eba-86cc-51ad8882346f",

        components = {
          {
            componentType = "parenting",
          },

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

            dimensions = {
              width = 2,
              height = 0.5,
            },
          },

          {
            componentType = "sprite",
            imagePath = "resources/images/hull.png",
          },

          {
            componentType = "script",
            scriptPath = "resources/scripts/CarScript.lua"
          },
        },
      },

      {
        uuid = "bb28a856-8892-4a45-aa5c-2af8a01dda00",

        components = {
          {
            componentType = "parenting",
            parentEntityUuid = "ed15bf2b-60ff-4eba-86cc-51ad8882346f",
          },

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
            imagePath = "resources/images/wheel.png",
          },
        },
      },

      {
        uuid = "b9d306e1-432f-40f6-9bcf-d606134a3c75",

        components = {
          {
            componentType = "parenting",
            parentEntityUuid = "ed15bf2b-60ff-4eba-86cc-51ad8882346f",
          },

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
            imagePath = "resources/images/wheel.png",
          },
        },
      },
    },
  })

  print(jsua.write(game:getConfig()))
end

function love.update(dt)
  game:update(dt)
end

function love.draw()
  game:draw()
end
