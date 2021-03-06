local common = {}

function common.findValue(t, value)
  for key, other in pairs(t) do
    if other == value then
      return key
    end
  end

  return nil
end

function common.removeValue(t, value)
  local key = common.findValue(t, value)

  if key ~= nil then
    t[key] = nil
  end

  return key
end

function common.findArrayValue(t, value)
  for i, other in ipairs(t) do
    if other == value then
      return i
    end
  end

  return nil
end

function common.removeArrayValue(t, value)
  local i = common.findArrayValue(t, value)

  if i ~= nil then
    table.remove(t, i)
  end

  return i
end

function common.findLastArrayValue(t, value)
  for i = #t, 1, -1 do
    if t[i] == value then
      return i
    end
  end

  return nil
end

function common.removeLastArrayValue(t, value)
  local i = common.findLastArrayValue(t, value)

  if i ~= nil then
    table.remove(t, i)
  end

  return i
end

function common.get2(t, x, y)
  return t[x] and t[x][y]
end

function common.set2(t, x, y, value)
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

return common
