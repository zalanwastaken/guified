local guified = require("libs/guified")
function love.load()
    guified.setWindowToBeOnTop()
    local button = guified.registry.elements.button.new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 40, 40, "Hello !")
    guified.registry.register(button)
end
function love.update(dt)
end
function love.draw()
end
