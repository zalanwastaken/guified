if guified == nil then
    error("You need to load Guified as a global first")
end
local tween = {
    newElementTween = function(element, x, y, time)
        local execen = false
        if element.changePos ~= nil then
            return({
                name = "TWEEN SVC for element "..element.name,
                draw = function()
                    
                end,
                update = function()
                    if execen then
                        element.changePos(x, y)
                    end
                end,
                exec = function()
                    execen = not(execen)
                end
            })
        end
    end
}
return(tween)
