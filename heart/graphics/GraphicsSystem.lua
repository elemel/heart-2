local GraphicsSystem = {}
GraphicsSystem.__index = GraphicsSystem

function GraphicsSystem.new(game, config)
  local system = setmetatable({}, GraphicsSystem)

  system.game = assert(game)
  system.game:addSystem(system)

  system.spriteComponents = {}

  return system
end

function GraphicsSystem:destroy()
  self.game:removeSystem(self)
  self.game = nil
end

function GraphicsSystem:getSystemType()
  return "graphics"
end

function GraphicsSystem:getConfig()
  return {
    systemType = "graphics",
  }
end

function GraphicsSystem:update(dt)
end

function GraphicsSystem:draw()
  for component, _ in pairs(self.spriteComponents) do
    local boneComponent = assert(component.boneComponent)
    local x, y = boneComponent:getWorldPosition()
    local angle = boneComponent:getWorldAngle()
    local scale = 1 / 16
    local width, height = component.image:getDimensions()
    love.graphics.draw(component.image, x, y, angle, scale, -scale, 0.5 * width, 0.5 * height)
  end
end

function GraphicsSystem:debugDraw()
end

return GraphicsSystem
