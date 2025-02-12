local guified = require("libs.guified.init")
local frame = require("libs.guified.modules.frame")
local frameobj = frame.new({
    guified.registry.elements.text:new(0, 15, guified.__VER__)
}, 0, 0, 150, 150, "Guified frame module")
frameobj:load()

--frameobj:addSlider(0, 0)

function love.update(dt)
    if love.keyboard.isDown("r") then
        frameobj.frame.changePos(love.math.random(0, love.graphics.getWidth()), love.math.random(0, love.graphics.getHeight()))
    end
end
