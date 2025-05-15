--! REACTOR IS NOT TO BE CONFUSED WITH REACT THEY ARE COMPLETELY DIFFERENT THINGS
--[[
*░▒▓███████▓▒░░▒▓████████▓▒░░▒▓██████▓▒░ ░▒▓██████▓▒░▒▓████████▓▒░▒▓██████▓▒░░▒▓███████▓▒░  
*░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ 
*░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        ░▒▓█▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ 
*░▒▓███████▓▒░░▒▓██████▓▒░ ░▒▓████████▓▒░▒▓█▓▒░        ░▒▓█▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░  
*░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        ░▒▓█▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ 
*░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ 
*░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░  ░▒▓█▓▒░   ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
--]]

if __GUIFIEDGLOBAL__ == nil then
    return nil
end

---@type guified
local guified = require(__GUIFIEDGLOBAL__.rootfolder..".init")
local logger = guified.debug.logger

local reactorinternal = {
    funcs = {
        draw = function(dirty)
            if not(dirty) then
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
        end
    },
    dirty = false
}

local reactor = {
    registry = {
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
            element = setmetatable({update = elementIMPL.update or nil, draw = elementIMPL.draw}, mt)
            guified.registry.register(element, idlen)
            reactorinternal.dirty = true
            return(element)
        end
    },
    settings = {
        --* works with most elements
        default = {
            setPOS = true,
            setWH = true,
            setText = true
        }
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
            reactorinternal.dirty = reactorinternal.dirty and not(reactorinternal.dirty)
        end
        if love.timer then
            love.timer.sleep(0.001)
        end
    end
end

return reactor
