if __GUIFIEDGLOBAL__ == nil then
    return nil
end

---@type guified
local guified = require(__GUIFIEDGLOBAL__.rootfolder..".init")
local logger = guified.debug.logger

local helper = {
    --TODO add more stuff here
    
    isValidElement = function(element)
        if not(element.draw or element.name or element.update) then
            return false
        else
            return true
        end
    end,
    typeCheckElement = function(element)
        if not(type(element.name):lower() == "string" or type(element.update):lower() == "function" or type(element.draw):lower() == "function") then
            return false
        else
            return true
        end
    end
}
