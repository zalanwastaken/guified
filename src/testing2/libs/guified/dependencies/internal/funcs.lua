---@class funcs
local funcs = {
    ---@param arg any
    ---@param argnum number
    ---@param expected string
    ---@param name string
    checkArg = function(arg, argnum, expected, name)
        local argtyp = type(arg)
        if argtyp:lower() ~= expected then
            error("Argument #" .. argnum .. " to " .. name .. " expected " .. expected .. " got " .. argtyp)
        end
    end,
    ---@param element element
    ---@return string
    formatElementForLogging = function(element)
        return(element.name..":"..element.id or "NO ID")
    end,

    types = {
        string = "string",
        number = "number",
        int = "number",
        dict = "table",
        table = "table",
        null = "nil",
        nil_val = "nil"
    }
}
return funcs
