local elementsinternal = {
    funcs = {
        checkArg = function(arg, argnum, expected, name)
            if type(arg):lower() ~= expected then
                error("Argument #"..argnum.." to "..name.." expected "..expected.." got "..type(arg))
            end
        end
    },
    types = {
        string = "string",
        number = "number",
        int = "number",
        dict = "table",
        table = "table",
        null = "nil",
        nil_val = "nil"
    }
}

---@class elements
local elements = {
    ---@param text string
    ---@param x number
    ---@param y number
    ---@param w number Optional
    ---@param h number Optional
    ---@param fgclr table Optional
    ---@param bgclr table Optional
    ---@param activebtn number Optional
    button = function(text, x, y, w, h, bgclr, fgclr, activebtn)
        bgclr = bgclr or {1, 1, 1, 1}
        fgclr = fgclr or {0, 0, 0, 1}
        w = w or #text * __GUIFIEDGLOBAL__.fontsize
        h = h or __GUIFIEDGLOBAL__.fontsize*2
        activebtn = activebtn or 1

        elementsinternal.funcs.checkArg(text, 1, elementsinternal.types.string, "button")
        elementsinternal.funcs.checkArg(x, 2, elementsinternal.types.int, "button")
        elementsinternal.funcs.checkArg(y, 3, elementsinternal.types.int, "button")

        local isPressed = false

        return({
            name = "button",
            draw = function()
                love.graphics.setColor(bgclr)
                love.graphics.rectangle("fill", x, y, w, h)
                love.graphics.setColor(fgclr)
                love.graphics.printf(text, x, y+h/5, w, "center")
            end,
            pressed = function()
                if love.mouse.isDown(activebtn) then
                    local mouseX, mouseY = love.mouse.getPosition()
                    if mouseX > x and mouseX < x+w and mouseY > y and mouseY < y+h then
                        isPressed = true
                        return true
                    end
                end
                return false
            end,
            released = function()
                if isPressed and not(love.mouse.isDown(activebtn)) then
                    isPressed = false
                    return true
                end
                return false
            end,

            updateFont = function()
                w = w or #text * __GUIFIEDGLOBAL__.fontsize
                h = h or __GUIFIEDGLOBAL__.fontsize*2
            end,
            setPOS = function(argx, argy)
                x = argx
                y = argy
            end,
            getPOS = function()
                return x, y
            end
        })
    end,

    ---@param text string
    ---@param x number Optional
    ---@param y number Optional
    text = function(text, x, y)
        x = x or 0
        y = y or 0

        elementsinternal.funcs.checkArg(text, 1, elementsinternal.types.string, "text")

        return({
            name = "text: "..text,
            draw = function()
                love.graphics.print(text, x, y)
            end
        })
    end,

    ---@param text string
    ---@param x number Optional
    ---@param y number Optional
    ---@param align string Optional
    ---@param maxalign number Optional
    textf = function(text, x, y, align, maxalign)
        maxalign = maxalign or love.graphics.getWidth()
        x = x or 0
        y = y or 0
        align = align or "center"

        elementsinternal.funcs.checkArg(text, 1, elementsinternal.types.string, "textf")

        return({
            name = "textf: "..text,
            draw = function()
                love.graphics.printf(text, x, y, maxalign, align)
            end
        })
    end,

    guifiedsplash = function()
        local largefont = love.graphics.newFont(20)
        local stdfont = __GUIFIEDGLOBAL__.font
        local quotes = {"Meow", "ZWT", "The CPU is a rock", "Lua > JS = true. Lua < JS = true. JS logic",
                        "{something = something}", "pog", "segfault(core dumped)", "404 quote not found", "OwO", ">_O"}
        local alpha = 1
        local quote = quotes[love.math.random(1, #quotes)]
        local done = false
        return ({
            name = "splash element",
            draw = function()
                love.graphics.setColor(0, 0, 0, alpha or 0)
                love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
                love.graphics.setColor(1, 1, 1, alpha or 0)
                love.graphics.setFont(largefont)
                love.graphics.printf("Guified", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
                love.graphics.setFont(stdfont)
                love.graphics.printf(quote, 0, (love.graphics.getHeight() / 2) + 25, love.graphics.getWidth(), "center")
            end,
            update = function(dt)
                if (alpha or -1) > 0 and not (done) then
                    alpha = alpha - 0.25 * dt
                else
                    done = true
                    alpha = nil
                end
            end,
            completed = function()
                return (done)
            end
        })
    end
}
return (elements)
