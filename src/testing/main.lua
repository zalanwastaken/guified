local profiler = require("profile")
profiler.start()
local guified = require("libs.guified.init")
local logger = guified.debug.logger

guified.registry.register(guified.elements.dropDown(0, 0, 80, 40, {"cat", "dog"}))

profiler.stop()
logger.debug(profiler.report(20))
