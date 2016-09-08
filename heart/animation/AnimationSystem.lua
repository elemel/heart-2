local AnimationSystem = {}
AnimationSystem.__index = AnimationSystem

function AnimationSystem.new(game, config)
  local system = setmetatable({}, AnimationSystem)

  system.game = assert(game)
  system.game:addSystem(system)

  return system
end

function AnimationSystem:destroy()
  self.game:removeSystem(self)
  self.game = nil
end

function AnimationSystem:getSystemType()
  return "animation"
end

function AnimationSystem:getConfig()
  return {
    type = "animation",
  }
end

function AnimationSystem:update(dt)
end

function AnimationSystem:draw()
end

return AnimationSystem
