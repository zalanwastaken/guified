local guified = require("libs.guified.init")
local logger = guified.debug.logger
local reactor = require("libs.guified.modules.experimental.reactor")

local txt = guified.elements.text("Hello World", 0, 0)

txt = reactor.registry.register(reactor.settings.default, txt)

function love.update()
    if love.keyboard.isDown("u") then
        if guified.registry.isRegistered(txt) then
            txt = reactor.registry.remove(txt)
        end
    end
end
