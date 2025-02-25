--! Tween module is still in testing

--TODO: complete this !

local guified = require(__GUIFIEDGLOBAL__.rootfolder.."init")
local tween = {
    newElementTween = function(element, x, y, sx, sy, time)
        if element.changePos ~= nil then
            local execen = false
            element.changePos(sx, sy)
            return({
                name = "TWEEN SVC for element "..element.name,
                draw = function()
                    element.draw()
                end,
                update = function()
                    if element.update ~= nil then
                        element.update()
                    end
                    if execen then
                        if sx > x then
                            x = x + 1
                        else
                            x = x - 1
                        end
                        if sy > y then
                            y = y + 1
                        else
                            y = y - 1
                        end
                        if sx == x and sy == y then
                            execen = not(execen)
                        end
                        element.changePos(x, y)
                    end
                end,
                exec = function()
                    execen = not(execen)
                end
            })
        else
            error("Element "..element.name.." cant be tweened")
        end
    end
}
return(tween)
