---@type guified
local guified = require("libs.guified.init")
local frame = require("libs.guified.modules.frame")
local tween = require("libs.guified.modules.tween")
local mimix = require("libs.guified.modules.mimix")
local frameobj = frame.new({
    guified.registry.elements.text:new(0, 15, guified.__VER__)
}, 0, 0, 150, 150, "Guified frame module")
frameobj:load()

local text_tween = tween.newElementTween(guified.registry.elements.text:new(0, 0, "henlo"), love.graphics.getWidth(),
    love.graphics.getHeight(), 2)
text_tween.start()
guified.registry.register(text_tween)

--guified.registry.register(mimix.init())

function love.update()
    if love.keyboard.isDown("r") then
        frameobj.frame.changePos(love.math.random(0, love.graphics.getWidth()),
            love.math.random(0, love.graphics.getHeight()))
    end
    if text_tween.isCompleted() then
        text_tween.newTarget(love.math.random(0, love.graphics.getWidth()),
            love.math.random(0, love.graphics.getHeight()))
        text_tween.start()
    end
    if love.keyboard.isDown("e") then --? Remove test
        frameobj:unload()
        if guified.funcs.isRegistered(text_tween) then
            guified.registry.remove(text_tween)
        end
    end
end
