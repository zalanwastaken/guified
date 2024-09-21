local guified = require("libs/guified")
function love.load()
    guified.setWindowToBeOnTop()
    button = guified.registry.elements.button.new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 40, 40, "Hello !")
    textbox = guified.registry.elements.textBox.new(0, 0, "GUIFIED VER.INF_DEV")
    guified.registry.register(textbox)
    guified.registry.register(button)
end
function love.update(dt)
    if button.pressed() then
        button.text("button was pressed")
        button.changePos(love.math.random(0, love.graphics.getWidth()), love.math.random(0, love.graphics.getHeight()))
    end
    if love.keyboard.isDown("space") then
        guified.registry.remove(button)
        guified.registry.remove(textbox)
    end
end
function love.draw()
end
