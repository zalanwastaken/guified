local guified = require("libs/guified")
function love.load()
    button = guified.registry.elements.button:new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 40, 40, "Hello !")
    guified.registry.register(button)
end
function love.update(dt)
    if button.pressed() then
        button.text("button was pressed")
        button.changePos(love.math.random(0, love.graphics.getWidth()), love.math.random(0, love.graphics.getHeight()))
    end
    if love.keyboard.isDown("space") then
        guified.registry.remove(button)
    end
end
function love.draw()
end
