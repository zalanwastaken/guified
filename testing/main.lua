---@type guified
local guified = require("libs.guified.init")
local frame = require("libs.guified.modules.frame")
---@type gradient
local gradient = require("libs.guified.modules.experimental.gradient")
local frameobj = frame.new({
    guified.registry.elements.text:new(0, 15, guified.__VER__)
}, 0, 0, 150, 150, "Guified frame module")
frameobj:load()

local grad = gradient:newGradient({1, 1, 1}, {1, 0, 0}, 100, 100)
guified.registry.register(grad)

function love.update()
    if love.keyboard.isDown("r") then
        frameobj.frame.changePos(love.math.random(0, love.graphics.getWidth()), love.math.random(0, love.graphics.getHeight()))
    end
    if love.keyboard.isDown("e") then
        error("?")
    end
    if love.keyboard.isDown("u") then
        guified.registry.remove(grad)
    end
end
