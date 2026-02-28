---@class funcs
local funcs = {
    ---@param arg any
    ---@param argnum number
    ---@param expected string
    ---@param name string
    checkArg = function(arg, argnum, expected)
        local info = debug.getinfo(2, "n") 
        local argtyp = type(arg)
        if argtyp:lower() ~= expected then
            error("Argument #" .. argnum .. " to " .. info.name .. " expected " .. expected .. " got " .. argtyp)
        end
    end,

    types = {
        string = "string",
        number = "number",
        int = "number",
        dict = "table",
        table = "table",
        null = "nil",
        nil_val = "nil",
        bool = "boolean"
    }
}
return funcs
