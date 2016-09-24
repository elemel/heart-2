local BorderWidget = require("heart.gui.BorderWidget")
local ColumnWidget = require("heart.gui.ColumnWidget")
local RowWidget = require("heart.gui.RowWidget")
local TableWidget = require("heart.gui.TableWidget")
local TextWidget = require("heart.gui.TextWidget")

return {
  newBorderWidget = BorderWidget.new,
  newColumnWidget = ColumnWidget.new,
  newRowWidget = RowWidget.new,
  newTableWidget = TableWidget.new,
  newTextWidget = TextWidget.new,
}
