--! Tween module is still in testing

---@return string
local function getScriptFolder()
    return (debug.getinfo(1, "S").source:sub(2):match("(.*/)"))
end
local function removeAfterLastSlash(str)
    local lastSlashIndex = str:match(".*()/")  -- Find the position of the last slash
    if lastSlashIndex then
        return str:sub(1, lastSlashIndex - 1)  -- Return the string up to the last slash
    else
        return str  -- No slashes found, return the original string
    end
end
local function replaceSlashWithDot(str)
    return str:gsub("/", ".")  -- Replace all '/' with '.'
end
--local guified = require("libs.guified.init")
local guified = require(replaceSlashWithDot(removeAfterLastSlash(removeAfterLastSlash(getScriptFolder()))..".init")) --TODO refactor
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
