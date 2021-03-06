function init()
end

function destroy()
end

function update(dt)
  if not self.revoluteJointComponents then
    self.revoluteJointComponents = entity:getDescendantComponents("revoluteJoint")
  end

  local leftInput = love.keyboard.isDown("a") or love.keyboard.isDown("left")
  local rightInput = love.keyboard.isDown("d") or love.keyboard.isDown("right")
  local inputX = (rightInput and 1 or 0) - (leftInput and 1 or 0)

  for i, jointComponent in ipairs(self.revoluteJointComponents) do
    jointComponent.joint:setMotorEnabled(true)
    jointComponent.joint:setMotorSpeed(inputX * 5)
    jointComponent.joint:setMaxMotorTorque(10)
  end
end

function debugDraw()
end
