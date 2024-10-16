local guified = require("libs/guified")
function love.load()
    textBox = guified.registry.elements.textInput.new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 40, 40, "test")
    textBox2 = guified.registry.elements.textInput.new(0, love.graphics.getHeight() / 2, 40, 40, "test")
    guified.registry.register(textBox)
    guified.registry.register(textBox2)
end
function love.update(dt)
end
function love.draw()
end
function love.keypressed(key)
    guified.registry.remove(textBox)
    guified.registry.remove(textBox2)
    
end
