local guified = require("libs.guified.init")
local frame = require("libs.guified.modules.frame")
local shotty = require("libs.guified.modules.shotty")
local frameobj = frame.new({
    guified.registry.elements.text:new(0, 15, guified.__VER__)
}, 0, 0, 150, 150, "Guified frame module")
frameobj:load()
--guified.debug.warn("meow")
if love.filesystem.getInfo("libs/guified/modules/c_modules/test.so") then
    require("libs.guified.modules.c_modules.test")
else
    guified.debug.logger.warn("Running without C modules")
end
