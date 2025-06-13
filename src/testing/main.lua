local guified = require("libs.guified.init")

local txt = guified.elements.text("hi", 0, 0)

guified.properties.initPropertySys(txt)

guified.properties.newProperty(txt, "textProp", "hi", function(val)
    txt.setText(val)
end)
guified.properties.newProperty(txt, "x", 0, function(val)
    local x, y = txt.getPOS()
    txt.setPOS(val, y)
end)
guified.properties.newProperty(txt, "y", 0, function(val)
    local x, y = txt.getPOS()
    txt.setPOS(x, val)
end)

guified.registry.register(txt)

function love.update(dt)
    if love.keyboard.isDown("d") then
        txt.textProp = "meow"
    end
    if love.keyboard.isDown("a") then
        txt.textProp = "meow :3"
    end
    if love.keyboard.isDown("up") then
        txt.y = txt.y - dt * 100
    end
    if love.keyboard.isDown("down") then
        txt.y = txt.y + dt * 100
    end
    if love.keyboard.isDown("left") then
        txt.x = txt.x - dt * 100
    end
    if love.keyboard.isDown("right") then
        txt.x = txt.x + dt * 100
    end
end
