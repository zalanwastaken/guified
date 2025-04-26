local profile = require("profile")
love.window.setTitle("disable hook meow") --? to disable guified window title hook

profile.start()

local guified = require("libs.guified.init")
local logger = guified.debug.logger

guified.registry.register(guified.elements.textInput(0, 0, 80, 40))

local splash = guified.elements.guifiedsplash()

guified.registry.register(splash)

profile.stop()

logger.debug(profile.report(20))

function love.update(dt)
    if splash.completed() and guified.registry.isRegistered(splash) then
        guified.registry.remove(splash)
    end
end

