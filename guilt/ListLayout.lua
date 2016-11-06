local ListLayout = {}
ListLayout.__index = ListLayout

function ListLayout.new(type)
  local layout = setmetatable({}, ListLayout)
  layout:init(type)
  return layout
end

function ListLayout:init(type)
  self.type = assert(type)
end

function ListLayout:measure(widget)
  local width, height = 0, 0

  for i, child in ipairs(widget.children) do
    local childWidth, childHeight = child:measure()

    if self.type == "column" then
      width = math.max(width, childWidth)
      height = height + childHeight
    elseif self.type == "row" then
      width = width + childWidth
      height = math.max(height, childHeight)
    else
      assert(false)
    end
  end

  return width, height
end

function ListLayout:arrange(widget)
  if self.type == "column" then
    local extraHeight = widget.height - widget.measuredHeight
    local childY = 0

    for i, child in ipairs(widget.children) do
      local childHeight = child.measuredHeight + extraHeight * child.normalizedWeight
      child:arrange(0, childY, widget.width, childHeight)
      childY = childY + childHeight
    end
  elseif self.type == "row" then
    local extraWidth = widget.width - widget.measuredWidth
    local childX = 0

    for i, child in ipairs(widget.children) do
      local childWidth = child.measuredWidth + extraWidth * child.normalizedWeight
      child:arrange(childX, 0, childWidth, widget.height)
      childX = childX + childWidth
    end
  else
    assert(false)
  end
end

return ListLayout
