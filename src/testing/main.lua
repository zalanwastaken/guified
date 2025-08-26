local guified = require("libs.guified.init")

local button = guified.elements.toggleButton(0, 0)

guified.registry.register(button)

local text = guified.elements.text("", 0, 100)
guified.properties.initPropertySys(text)
guified.properties.newProperty(text, "text", tostring(button.getState()), function(val)
    text.setText(val)
end)

guified.registry.register(text)

guified.registry.registerCallback(button.getState, function(val)
    text.text = tostring(val)
end)
