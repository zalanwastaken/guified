---@type guified
local guified = require("libs.guified.init")
local frame = require("libs.guified.modules.frame")
local tween = require("libs.guified.modules.tween")
local mimix
if love.filesystem.getInfo("libs/guified/modules/experimental/mimix.lua") then --? dont error out on unimplimented builds
    mimix = require("libs.guified.modules.experimental.mimix")
end

local grid = require("libs.guified.modules.experimental.grid")
local gridobj = grid.newGrid(0, 0, 0, 0)

for i = 1, 20, 1 do
    gridobj.register(guified.elements.text:new(0, 0, "meow"), 0, 12)
end
gridobj.enable()

local frameobj = frame.new({
    guified.elements.text:new(0, 15, guified.__VER__)
}, 0, 0, 200, 200, "Guified frame module")
frameobj:load()

local text_tween = tween.newElementTween(guified.elements.text:new(0, 0, "henlo"), love.graphics.getWidth(),
    love.graphics.getHeight(), 2)
text_tween.start()
guified.registry.register(text_tween)

--guified.registry.register(mimix.init())

local keyp = ""
guified.registry.register({
    name = "test for keypressed",
    draw = function()
        love.graphics.print(keyp, 0, love.graphics.getHeight() / 2)
    end,
    keypressed = function(key)
        keyp = key
    end
})

local splash = guified.elements.guifiedsplash:new()
guified.registry.register(splash)

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
            guified.registry.remove(text_tween.element)
        end
        gridobj.disable()
    end
    if love.keyboard.isDown("b") then
        error("test")
    end
    if splash.completed() and splash.id ~= nil then
        guified.registry.remove(splash)
    end
end
