local RowLayout = {}
RowLayout.__index = RowLayout

function RowLayout.new()
  local layout = setmetatable({}, RowLayout)
  layout:init()
  return layout
end

function RowLayout:init()
end

function RowLayout:measure(widget)
  local width, height = 0, 0

  for i, child in ipairs(widget.children) do
    local childWidth, childHeight = child:measure()
    width = width + childWidth
    height = math.max(height, childHeight)
  end

  return width, height
end

function RowLayout:arrange(widget)
  local extraWidth = widget.width - widget.measuredWidth
  local childX = 0

  for i, child in ipairs(widget.children) do
    local childWidth = child.measuredWidth + extraWidth * child.normalizedWeight
    child:arrange(childX, 0, childWidth, widget.height)
    childX = childX + childWidth
  end
end

return RowLayout
