if guified == nil then
    error("You need to load Guified as a global first")
end
local function createSlider(x, y) --TODO
    return({
        name = "Slider", 
        draw = function()
            love.graphics.rectangle("fill", x, y, 20, 80)
        end,
        update = function()
            
        end
    })
end
local frame = {
    __VER__ = {
        guified = "A-1.0.1", --* guified version
        module = "A-1.0.0" --* module version
    },
    ---@param elements table
    ---@return frame
    new = function(elements)
        ---@class frame
        local frame = {
            elements = elements,
            loaded = false,
            load = function(self)
                for i = 1, #elements, 1 do
                    guified.registry.register(elements[i])
                end
                self.loaded = true
            end,
            unload = function(self)
                for i = 1, #elements, 1 do
                    guified.registry.remove(elements[i])
                end
                self.loaded = false
            end,
            flip = function()
                --TODO
                local tmp = {}
                for i = 1, #elements, 1 do
                end
            end,
            addSlider = function(self, x, y)
                if self.loaded == true then
                    local slider = createSlider(x, y)
                    guified.registry.register(slider)
                    elements[#elements + 1] = slider
                    return(slider)
                end
            end
        }
        return(frame)
    end
}
return(frame)
