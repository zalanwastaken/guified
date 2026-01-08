local guified = require("libs.guified.init")
local logger = guified.debug.logger

local splash = guified.elements.guifiedsplash()
guified.registry.registerPollingCallback(splash.completed, {}, function()
    if guified.registry.isRegistered(splash) then
        guified.registry.remove(splash)
        return false
    end
end, true, "equal")
guified.registry.register(splash)
