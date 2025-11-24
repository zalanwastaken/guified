local guified = require("libs.guified.init")
local logger = guified.debug.logger

local button = guified.elements.button("Press Me !", 0, 0)
guified.registry.register(button)

local id = guified.registry.registerPollingCallback(button.released, {}, function()
    logger.info("button was pressed")
end, true, "equal")

guified.registry.register(guified.elements.textInput(0, 0, 90, 40))
