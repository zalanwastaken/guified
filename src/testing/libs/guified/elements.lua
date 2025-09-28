---@type funcs
local funcs = require(__GUIFIEDGLOBAL__.rootfolder..".dependencies.internal.funcs")
local elementsinternal = {
    funcs = {
        checkArg = funcs.checkArg
    },
    types = funcs.types
}
funcs = nil

---@class elements
local elements = {
    ---@param text string
    ---@param x number
    ---@param y number
    ---@param w? number Optional
    ---@param h? number Optional
    ---@param fgclr? Color Optional
    ---@param bgclr? Color Optional
    ---@param activebtn? number Optional
    ---@return element
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
    ---@param x? number Optional
    ---@param y? number Optional
    ---@return element
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
    ---@param x? number Optional
    ---@param y? number Optional
    ---@param align? string Optional
    ---@param maxalign? number Optional
    ---@return element
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
            end,

            ---@param argtext string
            setText = function(argtext)
                elementsinternal.funcs.checkArg(argtext, 1, elementsinternal.types.number, "setText")

                text = argtext
            end,

            ---@return string
            getText = function()
                return text
            end,

            ---@param argalign string
            setAlign = function(argalign)
                elementsinternal.funcs.checkArg(argalign, 1, elementsinternal.types.string, "setAlign")

                align = argalign
            end,

            ---@param argmaxalign number
            setMaxAlign = function(argmaxalign)
                elementsinternal.funcs.checkArg(argmaxalign, 1, elementsinternal.types.number, "setMaxAlign")

                maxalign = argmaxalign
            end,

            ---@return string
            getAlign = function()
                return align
            end,

            ---@return number
            getMaxAlign = function()
                return maxalign
            end
        })
    end,

    ---@param x number
    ---@param y number
    ---@param image string|image image or the path to the image file
    ---@return element
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
            end,

            setImage = function(argimg)
                if type(argimg):lower() == "string" then
                    argimg = love.graphics.newImage(argimg)
                end
                image = argimg
            end
        })
    end,

    ---@param x number
    ---@param y number
    ---@param w number
    ---@param h number
    ---@param mode? string optional fill or line
    ---@param bgclr? Color optional
    ---@param fgclr? Color optional
    ---@param placeholderTXT? Color optional
    ---@param activebtn? number optional. 1 = left, btn 2 = right btn
    ---@param activebydefault? boolean optional is the element active(selected) by default ?
    ---@param limit? number optional limit of the enterable text
    ---@return element
    textInput = function(x, y, w, h, mode, bgclr, fgclr, placeholderTXT, activebtn, activebydefault, limit)
        elementsinternal.funcs.checkArg(x, 1, elementsinternal.types.number, "textInput")
        elementsinternal.funcs.checkArg(y, 2, elementsinternal.types.number, "textInput")
        elementsinternal.funcs.checkArg(w, 3, elementsinternal.types.number, "textInput")
        elementsinternal.funcs.checkArg(h, 4, elementsinternal.types.number, "textInput")

        mode = mode or "fill"
        bgclr = bgclr or {1, 1, 1, 1}
        fgclr = fgclr or {0, 0, 0, 1}
        placeholderTXT = placeholderTXT or "Place Holder :3"
        activebtn = activebtn or 1
        limit = limit or 16

        if mode ~= "fill" and mode ~= "line" then
            error("Unknown mode please use:-\nline\nOR\nfill")
        end

        local txt = nil
        local wasdownbefore = false
        local active = activebydefault or false
        return({
            name = "textinput",
            draw = function()
                love.graphics.setColor(bgclr)
                love.graphics.rectangle(mode, x, y, w, h)

                love.graphics.setColor(fgclr)
                if txt ~= nil and active then
                    love.graphics.printf(txt.."|", x, y+(h/4), x+w, "center")
                elseif txt == nil then
                    love.graphics.printf(placeholderTXT, x, y+(h/4), x+w, "center")
                elseif txt ~= nil then
                    love.graphics.printf(txt, x, y+(h/4), x+w, "center")
                end
            end,
            update = function()
                if love.mouse.isDown(1) then
                    local mouseX, mouseY = love.mouse.getPosition()
                    if mouseX > x and mouseX < x+w and mouseY > y and mouseY < y+h then
                        if not(wasdownbefore) then
                            wasdownbefore = true
                            active = true
                        end
                    elseif wasdownbefore then
                        wasdownbefore = false
                        active = false
                    end
                end
            end,
            textinput = function(key)
                if active then
                    if txt == nil then
                        txt = ""
                    end

                    if not(#txt >= limit) then
                        txt = txt..key
                    end
                end
            end,
            keypressed = function(key)
                if key == "backspace" and txt ~= nil and active then
                    txt = string.sub(txt, 1, #txt-1)
                end

                if txt ~= nil then
                    if #txt == 0 then
                        txt = nil
                    end
                end
            end,

            ---@param argx number
            ---@param argy number
            setPOS = function(argx, argy)
                elementsinternal.funcs.checkArg(argx, 1, elementsinternal.types.number, "setPOS")
                elementsinternal.funcs.checkArg(argy, 2, elementsinternal.types.number, "setPOS")

                x = argx
                y = argy
            end,

            ---@param argbgclr Color
            ---@param argfgclr Color
            setClr = function(argbgclr, argfgclr)
                elementsinternal.funcs.checkArg(argfgclr, 1, elementsinternal.types.table, "setClr")
                elementsinternal.funcs.checkArg(argbgclr, 2, elementsinternal.types.table, "setClr")

                bgclr = argbgclr
                fgclr = argfgclr
            end,

            ---@param arglimit number
            setLimit = function(arglimit)
                elementsinternal.funcs.checkArg(arglimit, 1, elementsinternal.types.number, "setLimit")

                limit = arglimit
            end,

            ---@param argmode string
            setMode = function(argmode)
                elementsinternal.funcs.checkArg(argmode, 1, elementsinternal.types.string, "setMode")
                if argmode ~= "fill" and argmode ~= "line" then
                    error("Unknown mode please use:-\nline\nOR\nfill")
                end

                mode = argmode
            end,

            ---@return string
            getText = function()
                return(txt or "")
            end,

            ---@return boolean
            isActive = function()
                return active
            end,

            ---@return Color
            getClr = function()
                return bgclr, fgclr
            end,

            ---@return number
            getPOS = function()
                return x, y
            end,

            ---@param argtext string
            setText = function(argtext)
                elementsinternal.funcs.checkArg(argtext, 1, elementsinternal.types.string, "setText")

                txt = argtext
            end,

            ---@param argactive boolean
            setActive = function(argactive)
                active = argactive
            end
        })
    end,

    ---@param x number
    ---@param y number
    ---@param w? number Optional
    ---@param h? number Optional
    ---@param mode? string Optional
    ---@param clr? Color Optional
    ---@return element
    box = function(x, y, w, h, mode, clr)
        elementsinternal.funcs.checkArg(x, 2, elementsinternal.types.number, "box")
        elementsinternal.funcs.checkArg(y, 3, elementsinternal.types.number, "box")

        mode = mode or "line"
        w = w or 40
        h = h or 40
        clr = clr or {1, 1, 1, 1}

        return({
            name = "box",

            draw = function()
                love.graphics.setColor(clr)
                love.graphics.rectangle(mode, x, y, w, h)
            end,

            ---@param argx number
            ---@param argy number
            setPOS = function(argx, argy)
                elementsinternal.funcs.checkArg(argx, 1, elementsinternal.types.number, "setPOS")
                elementsinternal.funcs.checkArg(argy, 2, elementsinternal.types.number, "setPOS")

                x = argx
                y = argy
            end,

            ---@return number
            getPOS = function()
                return x, y
            end,

            ---@param argh number
            ---@param argw number
            setWH = function(argw, argh)
                elementsinternal.funcs.checkArg(argw, 1, elementsinternal.types.number, "setWH")
                elementsinternal.funcs.checkArg(argh, 2, elementsinternal.types.number, "setWH")

                w = argw
                h = argh
            end,

            setColor = function(argclr)
                elementsinternal.funcs.checkArg(argclr, 1, elementsinternal.types.table, "setColor")

                clr = argclr
            end
        })
    end,

    --[[
    dropDown = function(x, y, w, h, content, bgclr, fgclr, activebtn)
        fgclr = fgclr or {0, 0, 0, 1}
        bgclr = bgclr or {1, 1, 1, 1}
        activebtn = activebtn or 1

        local selcont = content[1]
        local active = false
        local wasdownbefore = false

        return({
            name = "dropdown",
            draw = function()
                if active then
                    for i = 1, #content, 1 do
                        love.graphics.setColor(bgclr)
                        love.graphics.rectangle("fill", x, (y+h)*i, w, h)

                        love.graphics.setColor(fgclr)
                        love.graphics.printf(content[i], x, ((y+h)*i)+__GUIFIEDGLOBAL__.fontsize/4, x+w, "center")
                    end
                else
                    love.graphics.setColor(bgclr)
                    love.graphics.rectangle("fill", x, y, w, h)

                    love.graphics.setColor(fgclr)
                    love.graphics.printf(selcont, x, y+(h/4), x+w, "center")
                end
            end,

            update = function()
                if love.mouse.isDown(activebtn) then
                    local mouseX, mouseY = love.mouse.getPosition()
                    if mouseX > x and mouseX < x+w and mouseY > y and mouseY < y+h then
                        if not(wasdownbefore) then
                            wasdownbefore = true
                            active = true
                        end
                    elseif wasdownbefore then
                        wasdownbefore = false
                        active = false
                    end
                end
            end
        })
    end,
    --]]

    ---@return element
    guifiedsplash = function()
        local largefont = love.graphics.newFont(20)
        local stdfont = __GUIFIEDGLOBAL__.font
        local quotes = {"Meow", "ZWT", "The CPU is a rock", "Lua > JS = true. Lua < JS = true. JS logic",
                        "{something = something}", "pog", "segfault(core dumped)", "404 quote not found", "OwO", ">_O",
                        "Miku", "Teto", "Hmmmmmmm", __GUIFIEDGLOBAL__.__VER__}
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

            ---@return boolean is the element done
            completed = function()
                return (done)
            end
        })
    end
}
return (elements)
