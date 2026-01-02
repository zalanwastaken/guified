local guified = require("libs.guified.init")
local logger = guified.debug.logger
local grid = require("libs.guified.modules.grid")

local mygrid = grid.newGrid("meow")

mygrid.addElement(1, guified.elements.text("Hallo", 0, 0), 20, 20, 20)
mygrid.addElement(2, guified.elements.text("Hallo", 0, 0), 20, 20, 20)
mygrid.addElement(1, guified.elements.text("Hallo", 0, 0), 20, 20, 20)

guified.registry.register(mygrid)

guified.registry.registerPollingCallback(love.keyboard.isDown, {"a"}, function()
    if guified.registry.isRegistered(mygrid) then
        guified.registry.remove(mygrid)
    end
end, true, "equal")

