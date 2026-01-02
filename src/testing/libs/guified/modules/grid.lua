if __GUIFIEDGLOBAL__ == nil then
    return nil
end

local guified = require("guified")

local grid = {
    newGrid = function(name)
        local data = {}
        local idxy = {}
        local elements = {}
        return({
            _guified = {
                name = (name or "unnamed").." grid",
                draw = function()
                    return
                end,
                onregister = function()
                    for i = 1, #elements, 1 do
                        guified.registry.register(elements[i])
                    end
                end,
                onremove = function()
                    for i = 1, #elements, 1 do
                        guified.registry.remove(elements[i])
                    end
                end
            },
            addElement = function(y, element, w, h, padding)
                if type(data[y]):lower() ~= "table" then
                    data[y] = {}
                end
                data[y][#data[y]+1] = {
                    element = element,
                    w = w,
                    h = h,
                    padding = padding
                }
                local setx, sety = 0, 0
                for i = 1, #idxy, 1 do
                    for f = 1, #data[idxy[i]], 1 do
                        if y == i then
                            setx = setx + data[i][f].w + data[i][f].padding
                        end
                        if not(y < i) and y ~= i then
                            sety = sety + data[i][f].h + data[i][f].padding
                        end
                    end
                end
                element.setPOS(setx, sety)
                elements[#elements+1] = element
                for i = 1, #idxy, 1 do
                    if idxy[i] > y then
                        table.insert(idxy, i, y)
                        return
                    end
                end
                idxy[#idxy+1] = y
            end
        })
    end
}

return grid
