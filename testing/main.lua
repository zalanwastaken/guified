guified = require("libs.guified.init")
require("libs.guified.modules.frame")
local colors = require("libs.guified.modules.colors")
function love.load()
    guified.setWindowToBeOnTop()
    movbox = guified.registry.elements.box:new(0, 0, 40, 40, "line", colors.electric_blue)
    frame = guified.frame.new({
        guified.registry.elements.textBox:new(0, 0, guified.__VER__),
        guified.registry.elements.textBox:new(love.graphics.getWidth() / 2, 0, "Hi !"),
        guified.registry.elements.box:new(0, 1, love.graphics.getWidth() - 1, love.graphics.getHeight() - 1, "line", colors.cyan),
        movbox
    })
    frame.load()
end
function love.update(dt)
    movbox.changeSize(love.mouse.getX(), love.mouse.getY())
end
function love.keypressed(key)
    if key == "u" then
        frame.unload()
    end
end
