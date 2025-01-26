guified = require("libs.guified.init") --? it is essencial that we load guified as a global
colors = require("libs.guified.modules.colors") --? colors does return a table contaning colors
function love.load()
    local box = guified.registry.elements.box:new(0, 1, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, "fill", colors.cyan) --? we use the cyan color from the colors module
    guified.registry.register(box)
end
