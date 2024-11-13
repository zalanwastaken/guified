guified = require("libs.guified.init")
local button = guified.registry.elements.button:new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 40, 40, "Hi")
local pts = 0
local ptscounter = guified.registry.elements.textBox:new(0, 0, pts)
function love.load()
    guified.registry.register(button)
    guified.registry.register(ptscounter)
end
function love.update()
    if button.pressed() then
        button.changePos(love.math.random(0, love.graphics.getWidth() - 40), love.math.random(0, love.graphics.getHeight() - 40))
        pts = pts + 1
        ptscounter.text(pts)
    end
end
