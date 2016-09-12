local ParentingSystem = {}
ParentingSystem.__index = ParentingSystem

function ParentingSystem.new(game, config)
  local system = setmetatable({}, ParentingSystem)
  system:init(game, config)
  return system
end

function ParentingSystem:init(game, config)
  self.game = assert(game)
  self.game:addSystem(self)
end

function ParentingSystem:destroy()
  if self.game then
    self.game:removeSystem(self)
    self.game = nil
  end
end

function ParentingSystem:getSystemType()
  return "parenting"
end

function ParentingSystem:getConfig()
  return {
    systemType = "parenting",
  }
end

function ParentingSystem:update(dt)
end

function ParentingSystem:draw()
end

function ParentingSystem:debugDraw()
end

return ParentingSystem
