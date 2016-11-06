local BorderWidget = require("guilt.BorderWidget")
local Gui = require("guilt.Gui")
local ListWidget = require("guilt.ListWidget")
local ScrollWidget = require("guilt.ScrollWidget")
local TextWidget = require("guilt.TextWidget")
local UserWidget = require("guilt.UserWidget")

return {
  newBorderWidget = BorderWidget.new,
  newColumnWidget = ListWidget.newColumn,
  newGui = Gui.new,
  newRowWidget = ListWidget.newRow,
  newScrollWidget = ScrollWidget.new,
  newTextWidget = TextWidget.new,
  newUserWidget = UserWidget.new,
}
