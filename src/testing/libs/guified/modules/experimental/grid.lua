if __GUIFIEDGLOBAL__ == nil then
    return nil
end

---@type guified
local guified = require(__GUIFIEDGLOBAL__.rootfolder..".init")
local logger = guified.debug.logger

local grid = {
    newGrid = function(sx, sy, ex, ey)
        local elements = {}
        local lastpos = {
            x = sx,
            y = sy
        } --? x, y
        local enabled = false
        return({
            ---@param element element
            ---@param paddingx number
            ---@param paddingy number
            register = function(element, paddingx, paddingy)
                element.changePos(lastpos.x, lastpos.y)
                lastpos.x = lastpos.x + paddingx
                lastpos.y = lastpos.y + paddingy
                elements[#elements + 1] = element
            end,

            ---@param elementno number
            remove = function(elementno)
                if not(enabled) then
                    table.remove(elements, elementno)
                else
                    logger.error("Grid needs to be disabled to be able to remove elements")
                end
            end,

            ---@param x number
            ---@param y number
            setlastpos = function(x, y)
                lastpos.x = x
                lastpos.y = y
            end,

            enable = function()
                if not(enabled) then
                    enabled = true
                    for i = 1, #elements, 1 do
                        guified.registry.register(elements[i])
                    end
                end
            end,

            disable = function()
                if enabled then
                    enabled = false
                    for i = 1, #elements, 1 do
                        guified.registry.remove(elements[i])
                    end
                end
            end,

            toggle = function()
                enabled = not(enabled)
            end
        })
    end
}

return grid
