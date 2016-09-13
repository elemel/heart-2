local ScriptingSystem = {}
ScriptingSystem.__index = ScriptingSystem

function ScriptingSystem.new(game, config)
  local system = setmetatable({}, ScriptingSystem)
  system:init(game, config)
  return system
end

function ScriptingSystem:init(game, config)
  self.game = assert(game)
  self.game:addSystem(self)

  self.environment = {
    assert = assert,
    ipairs = ipairs,
    love = love,
    pairs = pairs,
    print = print
  }

  self.environment.__index = self.environment

  self.scriptComponents = {}
end

function ScriptingSystem:destroy()
  if self.game then
    self.game:removeSystem(self)
    self.game = nil
  end
end

function ScriptingSystem:getSystemType()
  return "scripting"
end

function ScriptingSystem:getConfig()
  return {
    systemType = "scripting",
  }
end

function ScriptingSystem:addScriptComponent(component)
  self.scriptComponents[component] = true
end

function ScriptingSystem:removeScriptComponent(component)
  self.scriptComponents[component] = nil
end

function ScriptingSystem:update(dt)
  for component, _ in pairs(self.scriptComponents) do
    if component.script.update then
      component.script.update(component.script, dt)
    end
  end
end

function ScriptingSystem:draw()
end

function ScriptingSystem:debugDraw()
end

return ScriptingSystem
