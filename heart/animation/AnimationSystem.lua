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

  self.boneComponents = {}
end

function AnimationSystem:destroy()
  self.boneComponents = nil

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
  for component, _ in pairs(self.boneComponents) do
    local x, y = component:getWorldPosition()
    local angle = component:getWorldAngle()
    local x2 = x + math.cos(angle)
    local y2 = y + math.sin(angle)
    love.graphics.line(x, y, x2, y2)
  end
end

return AnimationSystem
