local BodyComponent = require("heart.physics.BodyComponent")
local CircleFixtureComponent = require("heart.physics.CircleFixtureComponent")
local PhysicsSystem = require("heart.physics.PhysicsSystem")
local RectangleFixtureComponent = require("heart.physics.RectangleFixtureComponent")
local RevoluteJointComponent = require("heart.physics.RevoluteJointComponent")

return {
  newBodyComponent = BodyComponent.new,
  newCircleFixtureComponent = CircleFixtureComponent.new,
  newPhysicsSystem = PhysicsSystem.new,
  newRectangleFixtureComponent = RectangleFixtureComponent.new,
  newRevoluteJointComponent = RevoluteJointComponent.new,
}
