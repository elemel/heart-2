local heart = {}

heart.graphics = require "heart.graphics"
heart.physics = require "heart.physics"
heart.transform = require "heart.transform"

local common = require "heart.common"
local Entity = require "heart.Entity"

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
end

function Game:removeSystem(system)
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
  if config.name == "graphics" then
    heart.graphics.newGraphicsSystem(game, config)
  elseif config.name == "physics" then
    heart.physics.newPhysicsSystem(game, config)
  elseif config.name == "transform" then
    heart.transform.newTransformSystem(game, config)
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
    local system = assert(self.systems.physics)
    heart.physics.newBody(system, entity, config)
  elseif config.name == "circleFixture" then
    local system = assert(self.systems.physics)
    heart.physics.newCircleFixture(system, entity, config)
  elseif config.name == "sprite" then
    local system = assert(self.systems.graphics)
    heart.graphics.newSprite(system, entity, config)
  elseif config.name == "transform" then
    self:loadTransform(entity, config)
  end
end

function Game:loadTransform(entity, config)
  local transform = heart.transform.newTransform(config)
  entity:addComponent(transform)
end

function Game:update(dt)
  for i, system in ipairs(self.systems) do
    system:update(dt)
  end
end

function Game:draw()
  local width, height = love.graphics:getDimensions()
  local scale = (1 / 4) * 0.5 * height

  love.graphics.translate(0.5 * width, 0.5 * height)
  love.graphics.scale(scale, -scale)
  love.graphics.setLineWidth(1 / scale)

  for i, system in ipairs(self.systems) do
    system:draw()
  end
end

return Game
