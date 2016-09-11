local ScriptComponent = {}
ScriptComponent.__index = ScriptComponent

function ScriptComponent.new(system, entity, config)
  local component = setmetatable({}, ScriptComponent)
  component:init(system, entity, config)
  return component
end

function ScriptComponent:init(system, entity, config)
  self.system = assert(system)
  self.system:addScriptComponent(self)

  self.entity = assert(entity)
  self.entity:addComponent(self)

  local mt = {
    assert = assert,
    component = self,
    entity = entity,
    game = system.game,
    ipairs = ipairs,
    love = love,
    pairs = pairs,
    print = print
  }

  mt.__index = mt

  self.script = {}
  setmetatable(self.script, mt)
  local scriptFunc = assert(loadfile("carScript.lua", "t", self.script))
  scriptFunc()
end

function ScriptComponent:destroy()
  self.entity:removeComponent(self)
  self.entity = nil

  self.system:removeScriptComponent(self)
  self.system = nil
end

function ScriptComponent:bind()
  if self.script.bind then
    self.script:bind()
  end
end

function ScriptComponent:getComponentType()
  return "script"
end

function ScriptComponent:getConfig()
  return {
    componentType = "script",
  }
end

return ScriptComponent
