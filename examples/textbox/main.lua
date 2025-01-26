local guified = require("libs/guified")
function love.load()
    textbox = guified.registry.elements.text:new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, guified.__VER__) --? the text element object
    guified.registry.register(textbox) --? register the element
end
function love.update(dt)
    if love.keyboard.isDown("space") then
        if textbox.id ~= nil then --? check if the element is registered
            guified.registry.remove(textbox) --? remove the element
        end
    end
end
function love.draw()
end
