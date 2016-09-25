local BorderWidget = require("guilt.BorderWidget")
local ColumnWidget = require("guilt.ColumnWidget")
local RowWidget = require("guilt.RowWidget")
local TableWidget = require("guilt.TableWidget")
local TextWidget = require("guilt.TextWidget")
local UserWidget = require("guilt.UserWidget")

return {
  newBorderWidget = BorderWidget.new,
  newColumnWidget = ColumnWidget.new,
  newRowWidget = RowWidget.new,
  newTableWidget = TableWidget.new,
  newTextWidget = TextWidget.new,
  newUserWidget = UserWidget.new,
}
