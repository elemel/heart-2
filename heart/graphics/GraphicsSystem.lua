local GraphicsSystem = {}
GraphicsSystem.__index = GraphicsSystem

function GraphicsSystem.new(game, config)
  local system = setmetatable({}, GraphicsSystem)
  system:init(game, config)
  return system
end

function GraphicsSystem:init(game, config)
  self.game = assert(game)
  self.game:addSystem(self)

  self.spriteComponents = {}
end

function GraphicsSystem:destroy()
  self.spriteComponents = nil

  if self.game then
    self.game:removeSystem(self)
    self.game = nil
  end
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
