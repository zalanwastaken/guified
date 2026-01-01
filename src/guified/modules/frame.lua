if __GUIFIEDGLOBAL__ == nil then --? check if guified is loaded
    return nil
end

---@type guified
local guified = require("guified") --? guified api
local logger = guified.debug.logger

local function createSlider(x, y) --TODO
    return({
        name = "Slider", 
        draw = function()
            love.graphics.rectangle("fill", x, y, 20, 80)
        end,
        update = function()
            
        end
    })
end

local function newFrameObj(x, y, w, h, bgclr, fgclr, borderclr, title, elements)
    bgclr = bgclr or {0.5, 0.5, 0.5, 1}
    fgclr = fgclr or {love.math.random(0, 255) / 100, love.math.random(0, 255) / 100, love.math.random(0, 255) / 100, 1}
    borderclr = borderclr or fgclr
    title = title or "Frame"
    local grabbeddata = { grabbed = false, x = 0, y = 0 }

    return {
        name = "Frame SVC",
        draw = function()
            --* border
            love.graphics.setColor(borderclr)
            love.graphics.rectangle("fill", x - 5, y - 5, w + 10, h + 10)

            --* background
            love.graphics.setColor(bgclr)
            love.graphics.rectangle("fill", x, y, w, h)

            --* top bar
            love.graphics.setColor(fgclr)
            love.graphics.rectangle("fill", x, y, w, 15)
            love.graphics.setColor(0, 0, 0)
            love.graphics.print(title, x + 5, y + 2)
            --love.graphics.setColor(bgclr)
            --love.graphics.rectangle("fill", x+w-15, y+2.5, 10, 10)
        end,

        update = function()
            local mouseX, mouseY = love.mouse.getPosition()
            if love.mouse.isDown(1) then
                if not grabbeddata.grabbed and mouseX > x and mouseX < x + w and mouseY > y and mouseY < y + 15 then
                    grabbeddata.grabbed = true
                    grabbeddata.x = mouseX
                    grabbeddata.y = mouseY
                end
            else
                grabbeddata.grabbed = false
            end
            
            if grabbeddata.grabbed then
                local xdiff, ydiff = mouseX - grabbeddata.x, mouseY - grabbeddata.y
                x, y = x + xdiff, y + ydiff
                grabbeddata.x, grabbeddata.y = mouseX, mouseY
                for i = 2, #elements, 1 do
                    if elements[i].changePos ~= nil and elements[i].getPos ~= nil then
                        local elementX, elementY = elements[i].getPos()
                        elements[i].setPOS(elementX + xdiff, elementY + ydiff)
                    else
                        logger.error(elements[i].name..":"..elements[i].id.." not movable")
                    end
                end
            end
        end,

        ---@param argh number
        ---@param argw number
        changeWH = function(argw, argh)
            w = argw
            h = argh
        end,

        ---@param argx number
        ---@param argy number
        changePOS = function(argx, argy)
            local xdiff, ydiff = argx - x, argy - y
            for i = 2, #elements, 1 do
                if elements[i].changePos ~= nil and elements[i].getPos ~= nil then
                    local elementX, elementY = elements[i].getPos()
                    elements[i].changePos(elementX + xdiff, elementY + ydiff)
                else
                    logger.error(elements[i].name.." not movable")
                end
            end
            x = argx
            y = argy
        end,

        ---@return number
        getPos = function()
            return x, y
        end,

        ---@param argbgclr Color
        ---@param argborderclr Color
        ---@param argfgclr Color
        setclrs = function(argbgclr, argfgclr, argborderclr)
            bgclr = argbgclr or bgclr
            fgclr = argfgclr or fgclr
            borderclr = argborderclr or argborderclr
        end,

        ---@param argx number
        ---@param argy number
        setPOS = function(argx, argy)
            x = argx
            y = argy
        end
    }
end

local frame = {
    --* creates a new frameobj
    ---@param elements table
    ---@param x number
    ---@param y number
    ---@param title string
    ---@param bgclr Color Optional
    ---@param fgclr Color Optional
    ---@param borderclr Color Optional
    ---@return frame
    new = function(elements, x, y, w, h, title, bgclr, fgclr, borderclr)
        local frameobj = newFrameObj(x, y, w, h, bgclr, fgclr, borderclr, title, elements)
        table.insert(elements, 1, frameobj)
        ---@class frame
        local frame = {
            frame = frameobj,
            elements = elements,
            loaded = false,
            load = function(self)
                if not(self.loaded) then
                    for i = 1, #elements, 1 do
                        guified.registry.register(elements[i])
                    end
                    self.loaded = true
                end
            end,
            unload = function(self)
                if self.loaded then
                    for i = 1, #elements, 1 do
                        guified.registry.remove(elements[i])
                    end
                end
                self.loaded = false
            end,
            addSlider = function(self, x, y)
                if self.loaded == true then
                    local slider = createSlider(x, y)
                    guified.registry.register(slider)
                    elements[#elements + 1] = slider
                    return(slider)
                end
            end
        }
        return(frame)
    end
}

logger.ok("Frame module loaded")
return(frame)
