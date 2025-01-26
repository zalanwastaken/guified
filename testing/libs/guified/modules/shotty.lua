if __GUIFIEDGLOBAL__ == nil then
    return nil
end
---@type guified
local guified = require(__GUIFIEDGLOBAL__.rootfolder.."init")
---@class shotty
local shotty = {
    elements = guified.registry.elements,
    register = guified.registry.register,
    remove = guified.registry.remove,
    extcalls = guified.extcalls,
    logger = guified.debug.logger
}
return(shotty)
