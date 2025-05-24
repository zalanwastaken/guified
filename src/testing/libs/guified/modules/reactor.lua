-- ! REACTOR IS NOT TO BE CONFUSED WITH REACT THEY ARE COMPLETELY DIFFERENT THINGS
--[[
*░▒▓███████▓▒░░▒▓████████▓▒░░▒▓██████▓▒░ ░▒▓██████▓▒░▒▓████████▓▒░▒▓██████▓▒░░▒▓███████▓▒░  
*░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ 
*░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        ░▒▓█▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ 
*░▒▓███████▓▒░░▒▓██████▓▒░ ░▒▓████████▓▒░▒▓█▓▒░        ░▒▓█▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░  
*░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        ░▒▓█▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ 
*░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ 
*░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░  ░▒▓█▓▒░   ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
? Welcome to a dirty system capable of reaching 900 FPS
--]] if __GUIFIEDGLOBAL__ == nil then
    return nil
end

---@type guified
local guified = require(__GUIFIEDGLOBAL__.rootfolder .. ".init")
local logger = guified.debug.logger
---@type funcs
local funcs = require(__GUIFIEDGLOBAL__.rootfolder .. ".dependencies.internal.funcs")

logger.info("Reactor init started")

local reactorinternal = {
    funcs = {
        draw = function(dirty)
            if not (dirty) then
                return nil
            end
            love.graphics.origin()
            love.graphics.clear(love.graphics.getBackgroundColor())
            -- * guified code
            if guified.registry.getDrawStatus() then
                guified.extcalls.drawf()
            end
            -- * guified code end
            love.graphics.present()
        end,
        merge = function(t1, t2)
            local result = {}
            for k, v in pairs(t1) do
                result[k] = v
            end
            for k, v in pairs(t2) do
                result[k] = v
            end
            return result
        end
    },
    internalregistry = {
        IMPL = {}
    },
    dirty = false
}

local reactor = {
    registry = {
        ---@param settings table
        ---@param element element
        ---@param idlen number optional
        register = function(settings, element, idlen)
            local elementIMPL = element
            local mt = {
                __index = function(tbl, key)
                    if settings[key] ~= nil then
                        reactorinternal.dirty = true
                    end
                    return elementIMPL[key]
                end
            }
            element = setmetatable({
                update = elementIMPL.update or nil,
                draw = elementIMPL.draw or nil
            }, reactorinternal.funcs.merge(getmetatable(element) or {}, mt))
            guified.registry.register(element, idlen)
            reactorinternal.internalregistry.IMPL[element.id] = elementIMPL
            reactorinternal.dirty = true
            return (element)
        end,
        ---@param element element
        remove = function(element)
            local ret = reactorinternal.internalregistry.IMPL[element.id]
            reactorinternal.internalregistry.IMPL[element.id] = nil
            guified.registry.remove(element)
            reactorinternal.dirty = true
            return (ret)
        end
    },
    settings = {
        -- * works with most elements
        default = {
            setPOS = true,
            setWH = true,
            setText = true
        },
        null = {}, -- ? bascially no settings
        ---@param setname table a array to gen settings for
        genSettings = function(setname)
            local ret = {}
            for i = 1, #setname, 1 do
                ret[setname[i]] = true
            end
            return ret
        end
    },
    funcs = {
        ---@param dirty boolean
        setDirty = function(dirty)
            funcs.checkArg(dirty, 1, funcs.types.bool, "setDirty")
            reactorinternal.dirty = dirty
        end
    }
}

-- * main love loop
function love.run()
    if love.load then
        love.load(love.arg.parseGameArguments(arg), arg)
    end
    -- * We don't want the first frame's dt to include time taken by love.load.
    if love.timer then
        love.timer.step()
    end
    local dt = 0
    -- * Main loop time.
    return function()
        -- * Process events.
        if love.event then
            love.event.pump()
            for name, a, b, c, d, e, f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return a or 0
                    end
                end
                love.handlers[name](a, b, c, d, e, f)
            end
        end
        -- * Update dt, as we'll be passing it to update
        if love.timer then
            dt = love.timer.step()
        end
        -- * guified code
        if guified.registry.getUpdateStatus() then
            guified.extcalls.updatef()
        end
        -- * guified code end
        -- Call update and draw
        if love.update then
            love.update(dt)
        end -- will pass 0 if love.timer is disabled
        if love.graphics and love.graphics.isActive() then
            reactorinternal.funcs.draw(reactorinternal.dirty)
            reactorinternal.dirty = reactorinternal.dirty and not (reactorinternal.dirty)
        end
        if love.timer then
            love.timer.sleep(0.001)
        end
    end
end
logger.ok("love.run override done")

function love.resize(w, h)
    guified.extcalls.resizef(w, h)
    reactorinternal.funcs.draw(true)
end
logger.ok("love.resize override done")
logger.ok("Reactor init done")
logger.warn("Reactor is experimental. Proceed like ur defusing a bomb")

return reactor
