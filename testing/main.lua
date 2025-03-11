---@type guified
local guified = require("libs.guified.init")
local frame = require("libs.guified.modules.frame")
local tween = require("libs.guified.modules.tween")
local frameobj = frame.new({
    guified.registry.elements.text:new(0, 15, guified.__VER__)
}, 0, 0, 150, 150, "Guified frame module")
frameobj:load()

local text = guified.registry.elements.text:new(0, 0, "henlo")
local text_tween = tween.newElementTween(text, love.graphics.getWidth(), love.graphics.getHeight(), 10)
text_tween.start()
guified.registry.register(text_tween)

function love.update()
    if love.keyboard.isDown("r") then
        frameobj.frame.changePos(love.math.random(0, love.graphics.getWidth()), love.math.random(0, love.graphics.getHeight()))
    end
    if love.keyboard.isDown("e") then
        error("?")
    end
    if text_tween.isCompleted() then
        text_tween.newTarget(love.math.random(0, love.graphics.getWidth()), love.math.random(0, love.graphics.getHeight()))
        text_tween.start()
    end
end
