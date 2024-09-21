local guified = require("libs/guified")
function love.load()
    textbox = guified.registry.elements.textBox.new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, "GUIFIED VER.INF_DEV")
    guified.registry.register(textbox)
end
function love.update(dt)
    if love.keyboard.isDown("space") then
        guified.registry.remove(textbox)
    end
end
function love.draw()
end
