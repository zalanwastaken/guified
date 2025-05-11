local guified = require("libs.guified.init")

--guified.registry.setDraw(false)
--guified.registry.setUpdate(false)

guified.registry.register(guified.elements.text("Hello World !", 0, 0))

--[[

function love.update(dt)
    guified.extcalls.updatef()
end

function love.draw()
    guified.extcalls.drawf()
end
--]]