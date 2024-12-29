guified = require("libs.guified.init")
local framemod = require("libs.guified.modules.frame")
local colors = require("libs.guified.modules.colors")
local tween = require("libs.guified.modules.tween")
function love.load()
    --guified.setWindowToBeOnTop()
    movbox = guified.registry.elements.box:new(0, 0, 40, 40, "line", colors.electric_blue)
    frame = framemod.new({
        guified.registry.elements.textBox:new(0, 0, guified.__VER__),
        guified.registry.elements.textBox:new(love.graphics.getWidth() / 2, 0, "Hi !"),
        guified.registry.elements.box:new(0, 1, love.graphics.getWidth() - 1, love.graphics.getHeight() - 1, "line", colors.cyan),
        movbox
    })
    frame:load()
    --print(frame:addSlider(30, 30).id)
    mouseLoc = guified.registry.elements.textBox:new(love.mouse.getX(), love.mouse.getY(), tostring(love.mouse.getX().."\n"..tostring(love.mouse.getY())))
    guified.registry.register(mouseLoc)
    local box = guified.registry.elements.box:new(0, 0, 40, 40, "fill", colors.green)
    local tweenO = tween.newElementTween(box, 0, 0, love.graphics.getWidth() - 40, love.graphics.getHeight() / 2)
    guified.registry.register(tweenO)
    tweenO.exec()
end
function love.update(dt)
    movbox.changeSize(love.mouse.getX(), love.mouse.getY())
    mouseLoc.changePos(love.mouse.getX() + 10, love.mouse.getY())
    mouseLoc.text("X:"..tostring(love.mouse.getX().."\nY:"..tostring(love.mouse.getY())))
    if love.keyboard.isDown("e") then
        error("TEST")
    end
end
function love.keypressed(key)
    if key == "u" then
        frame:unload()
        guified.registry.remove(mouseLoc)
    end
end
--? All of that without ever touching love.draw
