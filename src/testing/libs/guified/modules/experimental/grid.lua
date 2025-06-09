if __GUIFIEDGLOBAL__ == nil then
    return nil
end

---@type guified
local guified = require(__GUIFIEDGLOBAL__.rootfolder..".init")

local gridinternal = {
    stack = {
        nextX = 0,
        nextY = 0
    }
}

local grid = {
    newGrid = function(x, y, w, h)
        local elements = {}
        return({
            addElement = function(element, w, h, mode)
                if mode.type == "stack" then
                    element.setPOS(gridinternal.stack.nextX, gridinternal.stack.nextY)
                    gridinternal.stack.nextY = gridinternal.stack.nextY + h
                end
                guified.registry.register(element)
                elements[element.id] = element
            end
        })
    end
}

return grid
