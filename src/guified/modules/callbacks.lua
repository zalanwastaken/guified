--! THIS WILL BE REMOVED

if __GUIFIEDGLOBAL__ == nil then
    return nil
end

---@type guified
local guified = require(__GUIFIEDGLOBAL__.rootfolder..".init")
local logger = guified.debug.logger

local callbacks = {
    addCallback = function(element, eventname, callback)
        local waselementregistered = false
        if guified.registry.isRegistered(element) then
            logger.warn(element.name..":"..element.id.." is registered removing and re-registering to add callback")
            guified.registry.remove(element)
            waselementregistered = true
        end
        if element[eventname] ~= nil then
            logger.error("Event "..eventname.." is not empty in element "..element.name..":"..element.id or "NO ID")
            if waselementregistered then
                logger.error("Element "..element.name..":"..element.id or "NO ID".." was removed re-registering and aborting due to previous error")
                guified.registry.register(element)
            end
            logger.error("Callback addition for "..element.name..":"..element.id.."aborted")
            return nil
        end
        element[eventname] = callback
        guified.registry.register(element)
        logger.ok("Successful callback addition for element "..element.name..":"..element.id)
    end
}

return callbacks
