local guified = require("libs.guified")
function love.load()
    textbox = guified.registry.elements.textBox:new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, "Hello world !")
    guified.registry.register(textbox)
    guified.setWindowToBeOnTop()
end
