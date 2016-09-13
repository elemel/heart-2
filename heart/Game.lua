local animation = require("heart.animation")
local common = require("heart.common")
local graphics = require("heart.graphics")
local parenting = require("heart.parenting")
local physics = require("heart.physics")
local scripting = require("heart.scripting")

local Entity = require("heart.Entity")

local Game = {}
Game.__index = Game

function Game.new(config)
  local game = setmetatable({}, Game)
  game:init(config)
  return game
end

function Game:init(config)
  self.systems = {}
  self.entities = {}

  if config.systems then
    for i, systemConfig in ipairs(config.systems) do
      self:loadSystem(systemConfig)
    end
  end

  if config.entities then
    for i, entityConfig in ipairs(config.entities) do
      Entity.new(self, entityConfig)
    end
  end
end

function Game:addSystem(system)
  table.insert(self.systems, system)
  self.systems[system:getSystemType()] = system
end

function Game:removeSystem(system)
  self.systems[system:getSystemType()] = nil
  common.removeArrayValue(self.systems, system)
end

function Game:addEntity(entity)
  table.insert(self.entities, entity)
  self.entities[entity:getUuid()] = entity
end

function Game:removeEntity(entity)
  self.entities[entity:getUuid()] = nil
  common.removeArrayValue(self.entities, entity)
end

function Game:getEntity(key)
  return self.entities[key]
end

function Game:loadSystem(config)
  if config.systemType == "animation" then
    animation.newAnimationSystem(self, config)
  elseif config.systemType == "graphics" then
    graphics.newGraphicsSystem(self, config)
  elseif config.systemType == "parenting" then
    parenting.newParentingSystem(self, config)
  elseif config.systemType == "physics" then
    physics.newPhysicsSystem(self, config)
  elseif config.systemType == "scripting" then
    scripting.newScriptingSystem(self, config)
  end
end

function Game:loadComponent(entity, config)
  if config.componentType == "body" then
    local system = assert(self.systems.physics)
    physics.newBodyComponent(system, entity, config)
  elseif config.componentType == "bone" then
    local system = assert(self.systems.animation)
    animation.newBoneComponent(system, entity, config)
  elseif config.componentType == "circleFixture" then
    local system = assert(self.systems.physics)
    physics.newCircleFixtureComponent(system, entity, config)
  elseif config.componentType == "parenting" then
    local system = assert(self.systems.parenting)
    parenting.newParentingComponent(system, entity, config)
  elseif config.componentType == "rectangleFixture" then
    local system = assert(self.systems.physics)
    physics.newRectangleFixtureComponent(system, entity, config)
  elseif config.componentType == "revoluteJoint" then
    local system = assert(self.systems.physics)
    physics.newRevoluteJointComponent(system, entity, config)
  elseif config.componentType == "script" then
    local system = assert(self.systems.scripting)
    scripting.newScriptComponent(system, entity, config)
  elseif config.componentType == "sprite" then
    local system = assert(self.systems.graphics)
    graphics.newSpriteComponent(system, entity, config)
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
  love.graphics.scale(scale, scale)
  love.graphics.setLineWidth(1 / scale)

  for i, system in ipairs(self.systems) do
    system:draw()
  end

  for i, system in ipairs(self.systems) do
    system:debugDraw()
  end
end

return Game
