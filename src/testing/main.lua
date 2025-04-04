local guified = require("libs.guified")
local logger = guified.debug.logger
local elements = require("elements")

logger.info("USING: "..guified.__VER__)

local grid = elements.grid(10, 10, love.graphics.getWidth() - 10, love.graphics.getHeight() - 10)

guified.registry.register(grid)

function love.update(dt)
    grid.setDim(10, 10, love.graphics.getWidth() - 10, love.graphics.getHeight() - 10)
end
