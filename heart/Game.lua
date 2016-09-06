local Body = require "Body"
local common = require "common"
local Entity = require "Entity"
local PhysicsSystem = require "PhysicsSystem"
local Transform = require "Transform"
local TransformSystem = require "TransformSystem"
local World = require "World"

local Game = {}
Game.__index = Game

function Game.new()
  local game = setmetatable({}, Game)
  game:init()
  return game
end

function Game:init()
  self.systems = {}
  self.entities = {}
end

function Game:addSystem(system)
  table.insert(self.systems, system)
  self.systems[system.name] = system
  system.game = self
  system:start()
end

function Game:removeSystem(system)
  system:stop()
  system.game = nil
  self.systems[system.name] = nil
  common.removeArrayValue(self.systems, system)
end

function Game:load(config)
  if config.systems then
    self:loadSystems(config.systems)
  end

  if config.entities then
    self:loadEntities(config.entities)
  end
end

function Game:loadSystems(config)
  for i, systemConfig in ipairs(config) do
    self:loadSystem(systemConfig)
  end
end

function Game:loadSystem(config)
  if config.name == "transform" then
    self:addSystem(TransformSystem.new(config))
  elseif config.name == "physics" then
    self:addSystem(PhysicsSystem.new({config}))
  end
end

function Game:loadEntities(config, parent)
  for i, entityConfig in ipairs(config) do
    self:loadEntity(entityConfig, parent)
  end
end

function Game:loadEntity(config, parent)
  local entity = Entity.new()
  entity.game = self

  if parent then
    entity:setParent(parent)
  end

  if config.components then
    self:loadComponents(entity, config.components)
  end

  if config.children then
    self:loadEntities(config.children, entity)
  end

  return entity
end

function Game:loadComponents(entity, config)
  for i, componentConfig in ipairs(config) do
    self:loadComponent(entity, componentConfig)
  end
end

function Game:loadComponent(entity, config)
  if config.name == "body" then
    self.systems.physics:loadBody(entity, config)
  elseif config.name == "transform" then
    self:loadTransform(entity, config)
  elseif config.name == "world" then
    self:loadWorld(entity, config)
  end
end

function Game:loadTransform(entity, config)
  local transform = Transform.new(config)
  entity:addComponent(transform)
end

function Game:loadWorld(entity, config)
  local world = World.new(config)
  entity:addComponent(world)
end

function Game:update(dt)
  for i, system in ipairs(self.systems) do
    system:update(dt)
  end
end

function Game:draw()
  local width, height = love.graphics:getDimensions()
  local scale = 0.5 * height

  love.graphics.translate(0.5 * width, 0.5 * height)
  love.graphics.scale(scale)
  love.graphics.setLineWidth(1 / scale)
  love.graphics.circle("line", 0, 0, 1, 256)

  if self.root then
    drawEntity(self.root)
  end
end

function drawEntity(entity)
  local transform = entity.components.transform
  local sprite = entity.components.sprite

  if sprite then
    if transform then
      love.graphics.draw(sprite,
        transform.x, transform.y,
        transform.angle,
        transform.scaleX, transform.scaleY)
    else
      love.graphics.draw(sprite)
    end
  end

  if entity.children[1] then
    if transform then
      love.graphics.push()

      love.graphics.translate(transform.x, transform.y)
      love.graphics.rotate(transform.angle)
      love.graphics.scale(transform.scaleX, transform.scaleY)
    end

    for i, child in ipairs(entity.children) do
      drawEntity(child)
    end

    if transform then
      love.graphics.pop()
    end
  end
end

return Game
