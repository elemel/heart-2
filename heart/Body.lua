local Body = {}
Body.__index = Body

function Body.new(data)
  local body = setmetatable({}, Body)
  body.name = "body"

  if data.entity then
    data.entity:addComponent(self)
  end

  return body
end

function Body:destroy()
  self.entity:removeComponent(self)
end

function Body:start()
  local world = assert(self.entity.game.systems.physics.world)
  self.transform = assert(self.entity:getComponent("transform"))
  local x, y = self.transform:getPosition()
  self.body = love.physics.newBody(world, x, y, "dynamic")
  self.body:setUserData(self)
end

function Body:stop()
  self.body:destroy()
  self.body = nil
end

return Body
