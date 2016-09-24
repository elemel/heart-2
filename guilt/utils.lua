local utils = {}

function utils.findValue(t, value)
  for key, other in pairs(t) do
    if other == value then
      return key
    end
  end

  return nil
end

function utils.removeValue(t, value)
  local key = utils.findValue(t, value)

  if key ~= nil then
    t[key] = nil
  end

  return key
end

function utils.findArrayValue(t, value)
  for i, other in ipairs(t) do
    if other == value then
      return i
    end
  end

  return nil
end

function utils.removeArrayValue(t, value)
  local i = utils.findArrayValue(t, value)

  if i ~= nil then
    table.remove(t, i)
  end

  return i
end

function utils.findLastArrayValue(t, value)
  for i = #t, 1, -1 do
    if t[i] == value then
      return i
    end
  end

  return nil
end

function utils.removeLastArrayValue(t, value)
  local i = utils.findLastArrayValue(t, value)

  if i ~= nil then
    table.remove(t, i)
  end

  return i
end

function utils.get2(t, x, y)
  return t[x] and t[x][y]
end

function utils.set2(t, x, y, value)
  if value == nil then
    if t[x] then
      t[x][y] = nil

      if not next(t[x]) then
        t[x] = nil
      end
    end
  else
    if not t[x] then
      t[x] = {}
    end

    t[x][y] = value
  end
end

return utils
