if __GUIFIEDGLOBAL__ == nil then
    return nil
end

local gridInternal = {
    funcs = require(__GUIFIEDGLOBAL__.rootfolder .. ".dependencies.internal.funcs"),
}

local grid = {
    newGrid = function(sx, sy, ex, ey, idlen)
        local elemnts = {}
        local nextX = sx
        local nextY = sy
        return ({
            sx = sx,
            sy = sy,
            ex = ex,
            ey = ey,
            addElement = function(element, w, h, padding )
                if not(element.getPOS and element.setPOS) then
                    return nil
                end
                
            end
        })
    end
}
