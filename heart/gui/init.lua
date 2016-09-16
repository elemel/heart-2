local BorderWidget = require("heart.gui.BorderWidget")
local ColumnWidget = require("heart.gui.ColumnWidget")
local RowWidget = require("heart.gui.RowWidget")
local TextWidget = require("heart.gui.TextWidget")

return {
  newBorderWidget = BorderWidget.new,
  newColumnWidget = ColumnWidget.new,
  newRowWidget = RowWidget.new,
  newTextWidget = TextWidget.new,
}
