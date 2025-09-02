local guified = require("libs.guified.init")
local logger = guified.debug.asynclogger

local profile = require("profile")
profile.start()

local button = guified.elements.toggleButton(0, 0)

guified.registry.register(button)

local text = guified.elements.text("", 0, 100)
guified.properties.initPropertySys(text)
guified.properties.newProperty(text, "text", tostring(button.getState()), function(val)
    text.setText(val)
end)

guified.registry.register(text)

local cb = guified.registry.registerPollingCallback(button.getState, {}, function(val)
    text.text = tostring(val)
end)

guified.registry.registerPollingCallback(love.keyboard.isDown, {"a"}, function(val)
    if guified.registry.isCallbackRegistered(cb) then
        --guified.registry.removePollingCallback(cb)
        error("THIS IS A TEST")
    end
end, true)

profile.stop()
logger.info(profile.report(20))
