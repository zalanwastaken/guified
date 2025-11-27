if __GUIFIEDGLOBAL__ == nil then
    return nil
end

---@type guified
local guified = require("guified")
local logger = guified.debug.logger

local tween = {}

--* creates a new tween element 
---@param element element
---@param targetX number
---@param targetY number
---@param duration number seconds
function tween.newElementTween(element, targetX, targetY, duration)
    if not (element.getPOS and element.setPOS) then
        logger.error(element.name .. " cannot be tweened")
        return nil
    end

    local startX, startY = element.getPOS()
    local elapsedTime = 0
    local completed = true
    local hidden = false

    local tweenObject = {
        _guified = {
            name = "tween SVC for " .. element._guified.name,
            draw = function()
            end,
            update = function(dt)
                if completed then
                    return
                end

                local t = math.min(elapsedTime / duration, 1) -- Clamp between 0 and 1

                local newX = startX + (targetX - startX) * t
                local newY = startY + (targetY - startY) * t
                elapsedTime = elapsedTime + dt
                element.setPOS(math.floor(newX), math.floor(newY)) --! might cause the tween to be shakey

                if t >= 1 then
                    completed = true
                end

                if not(guified.registry.isRegistered(element)) then
                    guified.registry.register(element)
                end
            end
        },

        --* returns if the tween completed
        ---@return boolean
        isCompleted = function()
            return completed
        end,

        --* starts the tween 
        start = function()
            completed = false
        end,
        
        --* stops the tween 
        stop = function()
            completed = true
        end,

        --* shows the element(element is shown by default)
        show = function()
            guified.registry.register(element)
            hidden = false
        end,

        --* hides the elementt
        hide = function()
            guified.registry.remove(element)
            hidden = true
        end,

        --* sets a new target for the tween
        ---@param x number
        ---@param y number
        newTarget = function(x, y)
            startX, startY = element.getPos()
            targetX = x
            targetY = y
            elapsedTime = 0
        end,

        ---@type element
        element = element
    }

    return tweenObject
end

return tween
