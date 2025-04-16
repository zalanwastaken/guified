local guified = require("libs.guified")
local logger = guified.debug.logger

guified.elements.button()

guified.registry.register(guified.elements.button("Hello world !", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2))

guified.registry.register(guified.elements.text("hello world !"))

guified.registry.register(guified.elements.textf("Hello", 0, 0, "center"))
