local guified = require("libs.guified.init")
local logger = guified.debug.logger
local reactor = require("libs.guified.modules.reactor")

for i = 1, 10000, 1 do
    reactor.registry.register(reactor.settings.default, guified.elements.textInput(love.math.random(0, love.graphics.getWidth()), love.math.random(0, love.graphics.getHeight()), 40, 80))
end
