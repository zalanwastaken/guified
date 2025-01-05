---@return string
local function getScriptFolder()
    return (debug.getinfo(1, "S").source:sub(2):match("(.*/)"))
end
local function removeAfterLastSlash(str)
    local lastSlashIndex = str:match(".*()/")  -- Find the position of the last slash
    if lastSlashIndex then
        return str:sub(1, lastSlashIndex - 1)  -- Return the string up to the last slash
    else
        return str  -- No slashes found, return the original string
    end
end
local function replaceSlashWithDot(str)
    return str:gsub("/", ".")  -- Replace all '/' with '.'
end
--local guified = require("libs.guified.init")
local guified = require(replaceSlashWithDot(removeAfterLastSlash(removeAfterLastSlash(getScriptFolder()))..".init")) --TODO refactor
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
                for i = 1, #elements, 1 do
                    guified.registry.register(elements[i])
                end
                self.loaded = true
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
return(frame)
