local guified = require("libs.guified.init")
local grid = require("libs.guified.modules.experimental.grid")

local gridobj = grid.newGrid(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
local txt = guified.elements.text("FPS")
txt.update = function()
    txt.setText("FPS:"..tostring(love.timer.getFPS()))
end

gridobj.addElement(txt, 90, __GUIFIEDGLOBAL__.fontsize, grid.aligners.stack)
for i = 1, 10, 1 do
    gridobj.addElement(guified.elements.text("Hi!", 0, 0), 40, __GUIFIEDGLOBAL__.fontsize, grid.aligners.stack)
end
