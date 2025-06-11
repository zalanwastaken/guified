if __GUIFIEDGLOBAL__ == nil then
    return nil
end

---@type guified
local guified = require(__GUIFIEDGLOBAL__.rootfolder..".init")

local gridinternal = {
    ---@type funcs
    funcs = require(__GUIFIEDGLOBAL__.rootfolder..".dependencies.internal.funcs"),
    data = {}
}

local grid = {
    newGrid = function(x, y, w, h)
        gridinternal.funcs.checkArg(x, 1, gridinternal.funcs.types.number, "newGrid")
        gridinternal.funcs.checkArg(y, 2, gridinternal.funcs.types.number, "newGrid")
        gridinternal.funcs.checkArg(w, 3, gridinternal.funcs.types.number, "newGrid")
        gridinternal.funcs.checkArg(h, 4, gridinternal.funcs.types.number, "newGrid")

        local elements = {}
        return({
            addElement = function(element, w, h, aligner)
                gridinternal.funcs.checkArg(element, 1, gridinternal.funcs.types.table, "addElement")
                gridinternal.funcs.checkArg(w, 2, gridinternal.funcs.types.number, "addElement")
                gridinternal.funcs.checkArg(h, 3, gridinternal.funcs.types.number, "addElement")
                gridinternal.funcs.checkArg(aligner, 4, gridinternal.funcs.types.table, "addElement")

                local data = aligner.runable(element, x, y, w, h, gridinternal.data[aligner.name])
                gridinternal.data[aligner.name] = data
                guified.registry.register(element)
                elements[element.id] = element
            end
        })
    end,

    aligners = {
        stack = {
            name = "stack",
            runable = function(element, x, y, w, h, data)
                --? wont be run by the user so no type checking
                data = data or y
                element.setPOS(0, data)
                return data + h
            end
        }
    }
}

return grid
