local animation = require("heart.animation")
local common = require("heart.common")
local graphics = require("heart.graphics")
local physics = require("heart.physics")

local Entity = require("heart.Entity")

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
  self.systems[system:getSystemType()] = system
end

function Game:removeSystem(system)
  self.systems[system:getSystemType()] = nil
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
  if config.systemType == "animation" then
    animation.newAnimationSystem(game, config)
  elseif config.systemType == "graphics" then
    graphics.newGraphicsSystem(game, config)
  elseif config.systemType == "physics" then
    physics.newPhysicsSystem(game, config)
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
  table.insert(self.entities, entity)

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
  if config.componentType == "body" then
    local system = assert(self.systems.physics)
    physics.newBodyComponent(system, entity, config)
  elseif config.componentType == "circleFixture" then
    local system = assert(self.systems.physics)
    physics.newCircleFixtureComponent(system, entity, config)
  elseif config.componentType == "rectangleFixture" then
    local system = assert(self.systems.physics)
    physics.newRectangleFixtureComponent(system, entity, config)
  elseif config.componentType == "revoluteJoint" then
    local system = assert(self.systems.physics)
    physics.newRevoluteJointComponent(system, entity, config)
  elseif config.componentType == "sprite" then
    local system = assert(self.systems.graphics)
    graphics.newSpriteComponent(system, entity, config)
  elseif config.componentType == "transform" then
    local system = assert(self.systems.animation)
    animation.newTransformComponent(system, entity, config)
  end
end

function Game:getConfig()
  local config = {}

  if self.systems[1] then
    config.systems = {}

    for i, system in ipairs(self.systems) do
      table.insert(config.systems, system:getConfig())
    end
  end

  if self.entities[1] then
    config.entities = {}

    for i, entity in ipairs(self.entities) do
      table.insert(config.entities, entity:getConfig())
    end
  end

  return config
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
