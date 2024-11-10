guified = require("libs.guified.init") --? it is essencial that we load guified as a global
require("libs.guified.modules.frame") --? Frame does not return anything it injects to guified as guified.frame
function love.load()
    frame = guified.frame.new({
        --? elements to be in the frame need to be passed as a table
        guified.registry.elements.textBox:new(0, 0, guified.__VER__),
        guified.registry.elements.textBox:new(love.graphics.getWidth() / 2, 0, "Hi !"),
        guified.registry.elements.box:new(0, 1, love.graphics.getWidth() - 1, love.graphics.getHeight() - 1, "line"),
    }) --? will return a frame object
    frame:load() --? Use frame.load to register the elements in the frame
end
function love.update(dt)
    if love.keyboard.isDown("u") then
        frame:unload() --? Use frame.unload to unregister the elements in the frame
    end
end
