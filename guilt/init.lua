local BorderWidget = require("guilt.BorderWidget")
local Gui = require("guilt.Gui")
local ListWidget = require("guilt.ListWidget")
local ScrollWidget = require("guilt.ScrollWidget")
local TextWidget = require("guilt.TextWidget")
local UserWidget = require("guilt.UserWidget")

return {
  newBorderWidget = BorderWidget.new,
  newGui = Gui.new,
  newListWidget = ListWidget.new,
  newScrollWidget = ScrollWidget.new,
  newTextWidget = TextWidget.new,
  newUserWidget = UserWidget.new,
}
