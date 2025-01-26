local guified = require("libs/guified")
function love.load()
    button = guified.registry.elements.button:new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, "Hello !")
    guified.registry.register(button)
end
function love.update(dt)
    if button.pressed() then
        button.text("button was pressed")
    end
    if love.keyboard.isDown("space") then
        guified.registry.remove(button)
    end
end
