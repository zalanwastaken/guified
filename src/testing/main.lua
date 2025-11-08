local guified = require("libs.guified.init")
local logger = guified.debug.logger

guified.debug.setFilter({
    "ok",
    "info",
    "regular",
    "warn"
})

guified.registry.registerPollingCallback(love.keyboard.isDown, {"k"}, function(args)
    print("MEOW")
end, true)
