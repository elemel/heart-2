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
    type = "graphics",
  }
end

function GraphicsSystem:update(dt)
end

function GraphicsSystem:draw()
  for component, _ in pairs(self.spriteComponents) do
    local transformComponent = assert(component.transformComponent)
    local x, y = transformComponent:getPosition()
    local angle = transformComponent:getAngle()
    local scale = 1 / 16
    local width, height = component.image:getDimensions()
    love.graphics.draw(component.image, x, y, angle, scale, -scale, 0.5 * width, 0.5 * height)
  end
end

return GraphicsSystem
