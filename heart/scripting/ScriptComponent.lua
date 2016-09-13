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

  self.scriptPath = assert(config.scriptPath)

  self.script = {}
  setmetatable(self.script, self.system.environment)

  self.script.self = self.script
  self.script.properties = config.properties or {}
  self.script.component = self
  self.script.entity = self.entity
  self.script.game = self.system.game

  local scriptFunc = assert(loadfile(self.scriptPath, "t", self.script))
  scriptFunc()
end

function ScriptComponent:destroy()
  if self.script then
    self.script.destroy()
    self.script = nil
  end

  if self.entity then
    self.entity:removeComponent(self)
    self.entity = nil
  end

  if self.system then
    self.system:removeScriptComponent(self)
    self.system = nil
  end
end

function ScriptComponent:getComponentType()
  return "script"
end

function ScriptComponent:getConfig()
  return {
    componentType = "script",
    scriptPath = self.scriptPath,
    properties = self.script.properties,
  }
end

return ScriptComponent
