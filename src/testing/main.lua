local guified = require("libs.guified.init")
local logger = guified.debug.logger

guified.registry.register({
    _guified = {
        name = "test",
        draw = function()
            love.graphics.print("Hallo")
        end,
        update = function()
        end,
        keypressed = function(key)
            logger.debug(key)
        end,
        textinput = function(key)
            logger.debug(key)
        end,
        mousepressed = function(x, y, btn)
            logger.debug(btn)
        end,
        mousemoved = function(x, y)
            logger.debug(tostring(x).." "..tostring(y))
        end,
        resize = function(w, h)
            logger.debug(tostring(w).." "..tostring(h))
        end
    }
})
