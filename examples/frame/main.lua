local guified = require("libs.guified.init") --? it is essencial that we load guified as a global
local frame = require("libs.guified.modules.frame") --? Frame does not return anything it injects to guified as guified.frame
function love.load()
    frameobj = frame.new({
        guified.registry.elements.text:new(0, 0, guified.__VER__),
        guified.registry.elements.text:new(love.graphics.getWidth() / 2, 0, "Hi !"),
        guified.registry.elements.box:new(0, 1, love.graphics.getWidth() - 1, love.graphics.getHeight() - 1, "line")
    }) --? our frame object
    frameobj:load() --? Use frame.load to register the elements in the frame
end
function love.update(dt)
    if love.keyboard.isDown("u") then
        if frameobj.loaded then --? check if the frame is loaded
            frameobj:unload() --? Use frame.unload to unregister the elements in the frame
        end
    end
end
