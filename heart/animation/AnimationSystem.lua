local AnimationSystem = {}
AnimationSystem.__index = AnimationSystem

function AnimationSystem.new(game, config)
  local system = setmetatable({}, AnimationSystem)
  system:init(game, config)
  return system
end

function AnimationSystem:init(game, config)
  self.game = assert(game)
  self.game:addSystem(self)
end

function AnimationSystem:destroy()
  if self.game then
    self.game:removeSystem(self)
    self.game = nil
  end
end

function AnimationSystem:getSystemType()
  return "animation"
end

function AnimationSystem:getConfig()
  return {
    systemType = "animation",
  }
end

function AnimationSystem:update(dt)
end

function AnimationSystem:draw()
end

function AnimationSystem:debugDraw()
end

return AnimationSystem
