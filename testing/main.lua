local guified = require("libs.guified")
function love.load()
    guified.registry.register(guified.registry.elements.textBox:new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, "Hello, World !"))
end
