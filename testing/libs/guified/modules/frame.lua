if guified == nil then
    error("You need to load Guified as a global first")
end
local frame = {
    new = function(elements)
        return({
            elements = elements,
            load = function()
                for i = 1, #elements, 1 do
                    guified.registry.register(elements[i])
                end
            end,
            unload = function()
                for i = 1, #elements, 1 do
                    guified.registry.remove(elements[i])
                end
            end
        })
    end
}
guified["frame"] = frame
