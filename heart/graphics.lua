local graphics = {}

local GraphicsSystem = {}
GraphicsSystem.__index = GraphicsSystem

function graphics.newGraphicsSystem(game, config)
  local system = setmetatable({}, GraphicsSystem)

  system.name = "graphics"

  system.game = assert(game)
  system.game:addSystem(system)

  system.sprites = {}

  return system
end

function GraphicsSystem:destroy()
  self.game:removeSystem(self)
  self.game = nil
end

function GraphicsSystem:update(dt)
end

function GraphicsSystem:draw()
  for sprite, _ in pairs(self.sprites) do
    local transform = assert(sprite.transform)
    local x, y = transform:getPosition()
    local angle = transform:getAngle()
    local scale = 1 / 16
    local width, height = sprite.image:getDimensions()
    love.graphics.draw(sprite.image, x, y, angle, scale, -scale, 0.5 * width, 0.5 * height)
  end
end

local Sprite = {}
Sprite.__index = Sprite

function graphics.newSprite(system, entity, config)
  local sprite = setmetatable({}, Sprite)

  sprite.name = "sprite"

  sprite.system = assert(system)
  sprite.system.sprites[sprite] = true

  sprite.entity = assert(entity)
  sprite.entity:addComponent(sprite)

  sprite.transform = assert(sprite.entity:getComponent("transform"))
  sprite.image = love.graphics.newImage(config.image)
  sprite.image:setFilter("nearest", "nearest")

  return sprite
end

function Sprite:destroy()
  self.transform = nil

  self.entity:removeComponent(sprite)
  self.entity = nil

  self.system.sprites[self] = nil
  self.system = nil
end

return graphics
