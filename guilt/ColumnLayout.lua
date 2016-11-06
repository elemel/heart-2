local ColumnLayout = {}
ColumnLayout.__index = ColumnLayout

function ColumnLayout.new()
  local layout = setmetatable({}, ColumnLayout)
  layout:init()
  return layout
end

function ColumnLayout:init()
end

function ColumnLayout:measure(widget)
  local width, height = 0, 0

  for i, child in ipairs(widget.children) do
    local childWidth, childHeight = child:measure()
    width = math.max(width, childWidth)
    height = height + childHeight
  end

  return width, height
end

function ColumnLayout:arrange(widget)
  local extraHeight = widget.height - widget.measuredHeight
  local childY = 0

  for i, child in ipairs(widget.children) do
    local childHeight = child.measuredHeight + extraHeight * child.normalizedWeight
    child:arrange(0, childY, widget.width, childHeight)
    childY = childY + childHeight
  end
end

return ColumnLayout
