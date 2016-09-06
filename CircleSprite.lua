local CircleSprite = {}
CircleSprite.__index = CircleSprite

function CircleSprite.new(data)
  local sprite = setmetatable({}, CircleSprite)
  sprite.radius = data.radius or 1

  if data.entity then
    data.entity:addComponent(self)
  end

  return sprite
end

function CircleSprite:destroy()
  self.entity:removeComponent(self)
end

function CircleSprite:start()
end

function CircleSprite:stop()
end

function CircleSprite:draw()
  love.graphics.circle(0, 0, self.radius, 16)
end

return CircleSprite
