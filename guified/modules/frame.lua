local guified = require(__GUIFIEDGLOBAL__.rootfolder.."init")
local logger = require(__GUIFIEDGLOBAL__.rootfolder.."dependencies.love2d-tools.modules.logger.init")
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
    ---@param elements table
    ---@return frame
    new = function(elements)
        ---@class frame
        local frame = {
            elements = elements,
            loaded = false,
            load = function(self)
                if not(self.loaded) then
                    for i = 1, #elements, 1 do
                        guified.registry.register(elements[i])
                    end
                    self.loaded = true
                end
            end,
            unload = function(self)
                if self.loaded then
                    for i = 1, #elements, 1 do
                        guified.registry.remove(elements[i])
                    end
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
logger.ok("Frame module loaded")
return(frame)
