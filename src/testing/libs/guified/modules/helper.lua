if __GUIFIEDGLOBAL__ == nil then
    return nil
end

---@type guified
local guified = require(__GUIFIEDGLOBAL__.rootfolder..".init")
local logger = guified.debug.asynclogger

---@class helper
local helper = {
    --TODO add more stuff here

    --* checks if a element is valid
    ---@param element element
    ---@return boolean
    isValidElement = function(element)
        if not(element.update) then --? update is not a required function
            logger.warn("Type check: update function not found for element "..element.name)
        end
        if not(element.draw or element.name) then
            return false
        else
            return true
        end
    end,

    --* type checks the entries in a element
    ---@param element element
    ---@return boolean
    typeCheckElement = function(element)
        if not(type(element.name):lower() == "string" or type(element.update):lower() == "function" or type(element.draw):lower() == "function") then
            return false
        else
            return true
        end
    end,

    --* checks if the element is registered if registered then removes it
    ---@param element element
    ---@return boolean
    checkRemove = function(element)
        if guified.funcs.isRegistered(element) then
            guified.registry.remove(element)
            return true
        else
            return false
        end
    end,

    --* checks if the element is registered if not registered then registers it
    ---@param element element
    ---@return boolean
    checkRegister = function(element)
        if guified.funcs.isRegistered(element) then
            return false
        else
            guified.registry.register(element)
            return true
        end
    end,

    ---@type math
    math = require(__GUIFIEDGLOBAL__.rootfolder..".dependencies.love2d-tools.modules.math")
}
