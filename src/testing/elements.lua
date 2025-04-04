local elements = {
    grid = function(sx, sy, ex, ey)
        sx = sx or 0
        sy = sy or 0
        ex = ex or love.graphics.getWidth()
        ey = ey or love.graphics.getHeight()
        return ({
            name = "grid",
            draw = function()
                -- * x axis lines
                for i = 1, math.floor(ex / 10), 1 do
                    love.graphics.line(i * 10, sy, i * 10, ey)
                end

                -- * y axis lines
                for i = 1, math.floor(ey / 10), 1 do
                    love.graphics.line(sx, i * 10, ex, i * 10)
                end
            end,
            setDim = function(new_sx, new_sy, new_ex, new_ey)
                sx = new_sx or 0
                sy = new_sy or 0
                ex = new_ex or 0
                ey = new_ey or 0
            end
        })
    end
}

return elements
