local guified = require("libs.guified.init")
local logger = guified.debug.logger

local frame = require("libs.guified.modules.frame")

guified.registry.register(guified.elements.text("Hallo !"))
local frameobj = frame.new({}, 0, 0, 200, 200)
frameobj:load()
