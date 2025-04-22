love.window.setTitle("disable hook meow") --? to disable guified window title hook

local guified = require("libs.guified.init")
local logger = guified.debug.logger
local tween = require("libs.guified.modules.tween")

guified.registry.register(guified.elements.image(0, 0, "assets/name.png"))

print(tween)

local fpsx, fpsy = 0, 0

local fps_counter = {
    name = "FPS",
    draw = function()
        love.graphics.setColor(1, 0, 0)
        love.graphics.print(love.timer.getFPS(), fpsx, fpsy)
    end,
    setPOS = function(argx, argy)
        fpsx = argx
        fpsy = argy
    end,
    getPOS = function()
        return fpsx, fpsy
    end
}

local fps_tween = tween.newElementTween(fps_counter, love.math.random(0, love.graphics.getWidth()), love.math.random(0, love.graphics.getHeight()), 10)

guified.registry.register(fps_tween)

fps_tween.start()
