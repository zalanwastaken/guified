---@class elements
local elements = {
    button = {
        ---@param argtext string
        ---@param argx number
        ---@param argy number
        ---@param h number optional
        ---@param w number optional
        ---@return element
        new = function(self, argx, argy, argtext, w, h)
            local isPressed = false --? Track if the button is currently pressed
            local autoctl = true
            if w ~= nil and h ~= nil then
                autoctl = false
            end
            return ({
                name = "button",
                draw = function()
                    if autoctl then
                        -- Adjust button size to fit text
                        local charWidth = __GUIFIEDGLOBAL__.fontsize / 2 -- Approx width of each character in a monospace font
                        w = #argtext * charWidth + 20 -- Add padding to the width
                        h = __GUIFIEDGLOBAL__.fontsize + 10 -- Set height based on font size with padding
                        love.graphics.print(argtext, argx + (w / 2) - (#argtext * charWidth / 2),
                            argy + (h / 2) - (__GUIFIEDGLOBAL__.fontsize / 2))
                    else
                        love.graphics.print(argtext, argx, argy)
                    end
                    -- Draw the button
                    love.graphics.rectangle("line", argx, argy, w, h)
                end,
                pressed = function()
                    local mouseX, mouseY = love.mouse.getPosition()
                    if love.mouse.isDown(1) then
                        if mouseX >= argx and mouseX <= argx + w and mouseY >= argy and mouseY <= argy + h then
                            isPressed = true
                            return true
                        end
                    end
                    return false
                end,
                released = function()
                    if isPressed and not love.mouse.isDown(1) then
                        isPressed = false
                        return true -- Button was released
                    end
                    return false -- No release detected
                end,
                text = function(text)
                    argtext = text
                end,
                changePos = function(x, y)
                    argx = x
                    argy = y
                end,
                getPos = function()
                    return argx, argy
                end
            })
        end
    },

    text = {
        ---@param argx number
        ---@param argy number
        ---@param text string
        ---@return element
        new = function(self, argx, argy, text)
            return ({
                name = "Text",
                draw = function()
                    love.graphics.print(text, argx, argy)
                end,
                text = function(argtext)
                    if argtext == nil then
                        error("No text provided")
                    end
                    text = argtext
                end,
                changePos = function(x, y)
                    if x == nil or y == nil then
                        error("x or y is nil")
                    end
                    argx = x
                    argy = y
                end,
                getPos = function()
                    return argx, argy
                end
            })
        end
    },

    textInput = { -- * YAY !
        ---@param argx number
        ---@param argy number
        ---@param w number
        ---@param h number
        ---@param placeholder string
        ---@param active boolean
        new = function(self, argx, argy, w, h, placeholder, active)
            active = active or false
            placeholder = placeholder or "Type Away ~"
            local text = ""
            local box = {
                x = argx - w / 4,
                y = argy - (h / 2 - __GUIFIEDGLOBAL__.fontsize)
            }
            local backspaceact = false
            local clicked = false
            local ret = {
                name = "Text Input",
                draw = function(data)
                    love.graphics.rectangle("line", box.x, box.y, w, h)
                    if #text > 0 then
                        if active then
                            love.graphics.print(text.."|", argx, argy)
                        else
                            love.graphics.print(text, argx, argy)
                        end
                    else
                        love.graphics.print(placeholder, argx, argy)
                    end
                end,
                update = function(dt)
                    local mx, my = love.mouse.getPosition() -- Get mouse position
                    if mx >= box.x and mx <= box.x + w and my >= box.y and my <= box.y + h then
                        if love.mouse.isDown(1) then
                            if not clicked then -- If it wasn't already clicked
                                clicked = true
                                active = true -- Set active to true when clicked inside the box
                            end
                        end
                    else
                        if love.mouse.isDown(1) then
                            active = false -- Set active to false if clicked outside the box
                        end
                        clicked = false -- Reset click status when mouse is released or outside the box
                    end
                    if active and love.keyboard.isDown("backspace") then
                        if backspaceact == false then
                            text = string.sub(text, 1, -2)
                            backspaceact = true
                        end
                    else
                        backspaceact = false
                    end
                end,
                textinput = function(key)
                    if active then
                        text = text .. key
                    end
                end,
                getText = function()
                    return (text)
                end,
                setText = function(argtext)
                    text = argtext
                end,
                changePos = function(x, y)
                    argx = x
                    argy = y
                end,
                changeWH = function(argw, argh)
                    w = argw
                    h = argh
                end
            }
            return (ret)
        end
    },

    box = {
        ---@param clr Color
        ---@param h number
        ---@param w number
        ---@param mode string
        ---@param x number
        ---@param y number
        ---@return element
        new = function(self, x, y, w, h, mode, clr)
            clr = clr or {1, 1, 1, 1}
            return ({
                name = "box",
                draw = function()
                    love.graphics.setColor(clr)
                    love.graphics.rectangle(mode, x, y, w, h)
                end,
                changeSize = function(argw, argh)
                    if argw == nil or argh == nil then
                        error("W or H is nil")
                    end
                    h = argh
                    w = argw
                end,
                changePos = function(argx, argy)
                    if argx == nil or argy == nil then
                        error("x or y is nil")
                    end
                    x = argx
                    y = argy
                end,
                getPos = function()
                    return x, y
                end
            })
        end
    },

    image = {
        ---@param x number
        ---@param y number
        ---@param image image
        new = function(self, x, y, image) --TODO: Refactor 
            return ({
                name = "image",
                draw = function()
                    love.graphics.draw(image, x, y)
                end,
                changePos = function(argx, argy)
                    x = argx
                    y = argy
                end,
                getPos = function()
                    return x, y
                end
            })
        end
    }
}
return(elements)
