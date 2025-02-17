if __GUIFIEDGLOBAL__ == nil then
    return nil
end

---@type guified
local guified = require(__GUIFIEDGLOBAL__.rootfolder..".init")

---@class shotty
local shotty = {
    --? multiple cases for the picky

    --* Original case (unchanged)
    original = {
        elements = guified.registry.elements,
        register = guified.registry.register,
        remove = guified.registry.remove,
        extcalls = guified.extcalls,
        debug = guified.debug
    },

    --* camelCase
    camelCase = {
        elements = guified.registry.elements,
        register = guified.registry.register,
        remove = guified.registry.remove,
        extCalls = guified.extcalls,
        debug = guified.debug
    },

    --* snake_case
    snake_case = {
        elements = guified.registry.elements,
        register = guified.registry.register,
        remove = guified.registry.remove,
        extcalls = guified.extcalls,
        debug = guified.debug
    },

    --* SCREAMING_SNAKE_CASE
    SCREAMING_SNAKE_CASE = {
        ELEMENTS = guified.registry.elements,
        REGISTER = guified.registry.register,
        REMOVE = guified.registry.remove,
        EXTCALLS = guified.extcalls,
        DEBUG = guified.debug
    },

    --* PascalCase
    PascalCase = {
        Elements = guified.registry.elements,
        Register = guified.registry.register,
        Remove = guified.registry.remove,
        ExtCalls = guified.extcalls,
        Debug = guified.debug
    },

    --* Title Case (Each word starts with a capital letter)
    Title_Case = {
        Elements = guified.registry.elements,
        Register = guified.registry.register,
        Remove = guified.registry.remove,
        ExtCalls = guified.extcalls,
        Debug = guified.debug
    },

    --* lowerCamelCase
    lowerCamelCase = {
        elements = guified.registry.elements,
        register = guified.registry.register,
        remove = guified.registry.remove,
        extCalls = guified.extcalls,
        debug = guified.debug
    }
}

return shotty
