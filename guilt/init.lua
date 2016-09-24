local BorderWidget = require("guilt.BorderWidget")
local ColumnWidget = require("guilt.ColumnWidget")
local RowWidget = require("guilt.RowWidget")
local TableWidget = require("guilt.TableWidget")
local TextWidget = require("guilt.TextWidget")

return {
  newBorderWidget = BorderWidget.new,
  newColumnWidget = ColumnWidget.new,
  newRowWidget = RowWidget.new,
  newTableWidget = TableWidget.new,
  newTextWidget = TextWidget.new,
}
