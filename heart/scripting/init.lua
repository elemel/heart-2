local ScriptComponent = require("heart.scripting.ScriptComponent")
local ScriptingSystem = require("heart.scripting.ScriptingSystem")

return {
  newScriptComponent = ScriptComponent.new,
  newScriptingSystem = ScriptingSystem.new,
}