local guified = require("libs.guified.init")

local button = guified.elements.toggleButton(0, 0)

guified.registry.register(button)

local text = guified.elements.text("", 0, 100)
guified.properties.initPropertySys(text)
guified.properties.newProperty(text, "text", tostring(button.getState()), function(val)
    text.setText(val)
end)

guified.registry.register(text)

local cb = guified.registry.registerCallback(button.getState, {""}, function(val)
    text.text = tostring(val)
end)

guified.registry.registerCallback(love.keyboard.isDown, {"a"}, function(val)
    if val and guified.registry.isCallbackRegistered(cb) then
        guified.registry.removeCallback(cb)
    end
end)
