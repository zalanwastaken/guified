---@class elementsinternal
local elementsinternal = {
    funcs = {
        ---@param arg any
        ---@param argnum number
        ---@param expected string
        ---@param name string
        checkArg = function(arg, argnum, expected, name)
            if type(arg):lower() ~= expected then
                error("Argument #" .. argnum .. " to " .. name .. " expected " .. expected .. " got " .. type(arg))
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
        elementsinternal.funcs.checkArg(text, 1, elementsinternal.types.string, "button")
        elementsinternal.funcs.checkArg(x, 2, elementsinternal.types.int, "button")
        elementsinternal.funcs.checkArg(y, 3, elementsinternal.types.int, "button")

        bgclr = bgclr or {1, 1, 1, 1}
        fgclr = fgclr or {0, 0, 0, 1}
        w = w or #text * __GUIFIEDGLOBAL__.fontsize
        h = h or __GUIFIEDGLOBAL__.fontsize * 2
        activebtn = activebtn or 1

        local isPressed = false

        return ({
            name = "button",
            draw = function()
                love.graphics.setColor(bgclr)
                love.graphics.rectangle("fill", x, y, w, h)
                love.graphics.setColor(fgclr)
                love.graphics.printf(text, x, y + h / 5, w, "center")
            end,

            ---@return boolean
            pressed = function()
                if love.mouse.isDown(activebtn) then
                    local mouseX, mouseY = love.mouse.getPosition()
                    if mouseX > x and mouseX < x + w and mouseY > y and mouseY < y + h then
                        isPressed = true
                        return true
                    end
                end
                return false
            end,

            ---@return boolean
            released = function()
                if isPressed and not (love.mouse.isDown(activebtn)) then
                    isPressed = false
                    return true
                end
                return false
            end,

            --? updates element data according to the font
            updateFont = function()
                w = w or #text * __GUIFIEDGLOBAL__.fontsize
                h = h or __GUIFIEDGLOBAL__.fontsize * 2
            end,

            --? changes the position of the element
            ---@param argx number
            ---@param argy number
            setPOS = function(argx, argy)
                elementsinternal.funcs.checkArg(argx, 1, elementsinternal.types.number, "SetPOS")
                elementsinternal.funcs.checkArg(argy, 2, elementsinternal.types.number, "setPOS")

                x = argx
                y = argy
            end,

            --? returns the position of the element
            ---@return number The position. x, y
            getPOS = function()
                return x, y
            end
        })
    end,

    ---@param text string
    ---@param x number Optional
    ---@param y number Optional
    text = function(text, x, y)
        elementsinternal.funcs.checkArg(text, 1, elementsinternal.types.string, "text")

        x = x or 0
        y = y or 0

        return ({
            name = "text: " .. text,
            draw = function()
                love.graphics.print(text, x, y)
            end,

            --? changes the text to display
            ---@param argtext string
            setText = function(argtext)
                elementsinternal.funcs.checkArg(argtext, 1, elementsinternal.types.string, "setText")

                text = argtext
            end,

            --? changes the position of the element
            ---@param argx number
            ---@param argy number
            setPOS = function(argx, argy)
                elementsinternal.funcs.checkArg(argx, 1, elementsinternal.types.number, "SetPOS")
                elementsinternal.funcs.checkArg(argy, 2, elementsinternal.types.number, "setPOS")

                x = argx
                y = argy
            end,

            --? returns the postion of the element
            ---@return number The position. x, y
            getPOS = function()
                return x, y
            end
        })
    end,

    ---@param text string
    ---@param x number Optional
    ---@param y number Optional
    ---@param align string Optional
    ---@param maxalign number Optional
    textf = function(text, x, y, align, maxalign)
        elementsinternal.funcs.checkArg(text, 1, elementsinternal.types.string, "textf")

        maxalign = maxalign or love.graphics.getWidth()
        x = x or 0
        y = y or 0
        align = align or "center"

        return ({
            name = "textf: " .. text,
            draw = function()
                love.graphics.printf(text, x, y, maxalign, align)
            end,

            --? changes the position of the element
            ---@param argx number
            ---@param argy number
            setPOS = function(argx, argy)
                elementsinternal.funcs.checkArg(argx, 1, elementsinternal.types.number, "SetPOS")
                elementsinternal.funcs.checkArg(argy, 2, elementsinternal.types.number, "setPOS")

                x = argx
                y = argy
            end,

            --? returns the position of the element
            ---@return number
            getPOS = function()
                return x, y
            end
        })
    end,

    ---@param x number
    ---@param y number
    ---@param image string|image image or the path to the image file
    image = function(x, y, image)
        elementsinternal.funcs.checkArg(x, 1, elementsinternal.types.number, "image")
        elementsinternal.funcs.checkArg(y, 2, elementsinternal.types.number, "image")

        if type(image):lower() == "string" then --? check if the image path was given
            image = love.graphics.newImage(image)
        end

        return ({
            name = "image",
            draw = function()
                love.graphics.draw(image, x, y)
            end,

            --? changes the position of the element
            ---@param argx number
            ---@param argy number
            setPOS = function(argx, argy)
                elementsinternal.funcs.checkArg(argx, 1, elementsinternal.types.number, "SetPOS")
                elementsinternal.funcs.checkArg(argy, 2, elementsinternal.types.number, "setPOS")

                x = argx
                y = argy
            end,

            --? returns the position of the element
            ---@return number
            getPOS = function()
                return x, y
            end
        })
    end,

    textInput = function()
        -- TODO
    end,

    guifiedsplash = function()
        local largefont = love.graphics.newFont(20)
        local stdfont = __GUIFIEDGLOBAL__.font
        local quotes = {"Meow", "ZWT", "The CPU is a rock", "Lua > JS = true. Lua < JS = true. JS logic",
                        "{something = something}", "pog", "segfault(core dumped)", "404 quote not found", "OwO", ">_O",
                        "Miku", "Teto", "Hmmmmmmm"}
        local alpha = 1
        local quote = quotes[love.math.random(1, #quotes)]
        local done = false
        return ({
            name = "splash element guified",
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

            ---@return boolean is the anim done
            completed = function()
                return (done)
            end
        })
    end
}
return (elements)
