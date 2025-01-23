if __GUIFIEDGLOBAL__ == nil then
    return nil
end
local guified = require(__GUIFIEDGLOBAL__.rootfolder.."init")
local logger = require(__GUIFIEDGLOBAL__.rootfolder.."dependencies.love2d-tools.modules.logger.init")
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
local function newFrameObj(x, y, w, h, bgclr, fgclr, title, elements)
    bgclr = bgclr or {0.5, 0.5, 0.5, 1}
    fgclr = fgclr or {love.math.random(0, 255) / 100, love.math.random(0, 255) / 100, love.math.random(0, 255) / 100, 1}
    title = title or "Frame"
    local grabbeddata = { grabbed = false, x = 0, y = 0 }

    return {
        name = "Frame SVC",
        draw = function()
            --* background
            love.graphics.setColor(bgclr)
            love.graphics.rectangle("fill", x, y, w, h)

            --* top bar
            love.graphics.setColor(fgclr)
            love.graphics.rectangle("fill", x, y, w, 15)
            love.graphics.setColor(0, 0, 0)
            love.graphics.print(title, x + 5, y + 2)
            love.graphics.setColor(bgclr)
            love.graphics.rectangle("fill", x+w-15, y+2.5, 10, 10)
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
                    local elementX, elementY = elements[i].getPos()
                    elements[i].changePos(elementX + xdiff, elementY + ydiff)
                end
            end
        end
    }
end

local frame = {
    ---@param elements table
    ---@return frame
    new = function(elements, x, y, w, h, title, bgclr, fgclr)
        table.insert(elements, 1, newFrameObj(x, y, w, h, bgclr, fgclr, title, elements))
        ---@class frame
        local frame = {
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
            flip = function()
                --TODO
                local tmp = {}
                for i = 1, #elements, 1 do
                end
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
