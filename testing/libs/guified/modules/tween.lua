---@type guified
local guified = require(__GUIFIEDGLOBAL__.rootfolder .. ".init")
local logger = guified.debug.logger

local tween = {}

---@param element element
---@param targetX number
---@param targetY number
---@param duration number seconds
function tween.newElementTween(element, targetX, targetY, duration)
    if not (element.getPos and element.changePos) then
        logger.error(element.name .. " cannot be tweened")
        return nil
    end

    local startX, startY = element.getPos()
    local elapsedTime = 0
    local completed = true

    local tweenObject = {
        name = "tween SVC for " .. element.name,
        draw = function()
            element.draw()
        end,
        update = function(dt)
            if element.update then
                element.update(dt)
            end
            if completed then
                return
            end

            local t = math.min(elapsedTime / duration, 1) -- Clamp between 0 and 1

            local newX = startX + (targetX - startX) * t
            local newY = startY + (targetY - startY) * t
            elapsedTime = elapsedTime + dt
            element.changePos(newX, newY)

            if t >= 1 then
                completed = true
            end
        end,
        isCompleted = function(self)
            return completed
        end,
        start = function()
            completed = false
        end,
        newTarget = function(x, y)
            startX, startY = element.getPos()
            targetX = x
            targetY = y
            elapsedTime = 0
        end
    }

    return tweenObject
end

return tween
