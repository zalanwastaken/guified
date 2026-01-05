if __GUIFIEDGLOBAL__ == nil then
    return nil
end

local guified = require("guified")

guified.funcs.setDraw(false)

local reactorinternal = {
    dirty = false,
    watchdogdata = {}
}

reactorinternal.watchDog = {
    _guified = {
        name = "reactor SVC watchdog",
        draw = function()
        end,
        update = function()
            local idtbl = guified.registry.getIdTable()
            if idtbl ~= reactorinternal.watchdogdata then
                reactorinternal.watchdogdata = idtbl
                reactorinternal.dirty = true
            end
        end
    }
}
guified.registry.register(reactorinternal.watchDog)

local reactor = {
    setDirty = function(arg)
        reactorinternal.dirty = arg or true
    end
}

function love.draw()
    if reactorinternal.dirty then
        guified.extcalls.drawf()
    end
end

return reactor
