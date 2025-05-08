if __GUIFIEDGLOBAL__ == nil then
    return nil
end

---@type guified
local guified = require(__GUIFIEDGLOBAL__.rootfolder..".init")
local logger = guified.debug.logger

local callbacksinternal = {
    json = require(__GUIFIEDGLOBAL__.rootfolder..".dependencies.love2d-tools.modules.database.json.json"),
    commstack = {}
}

callbacksinternal.pushtostack = function(msg)
    callbacksinternal.commstack[#callbacksinternal.commstack + 1] = msg
end
callbacksinternal.popfromstack = function()
    local ret = callbacksinternal.commstack[1]
    table.remove(callbacksinternal.commstack, 1)
    return ret
end

local callbacks = {
    initCallbackSystem = function()
        guified.registry.register({
            name = "callbacks SVC",
            draw = function()
                
            end,
            update = function()
                
            end
        })
    end,
    addCallback = function(element, eventname, firetype, callback)
        if type(element[eventname]):lower() == "function" then
            
        else
            logger.error("Cant add callback for element "..element.name)
        end
    end
}

return callbacks
