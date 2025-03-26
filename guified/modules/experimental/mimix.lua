--[[
* __  __ _           _      
*|  \/  (_)         (_)     
*| \  / |_ _ __ ___  ___  __
*| |\/| | | '_ ` _ \| \ \/ /
*| |  | | | | | | | | |>  < 
*|_|  |_|_|_| |_| |_|_/_/\_\
--]]

if __GUIFIEDGLOBAL__ == nil then
    return nil
end

---@type guified
local guified = require(__GUIFIEDGLOBAL__.rootfolder..".init")
local logger = guified.debug.logger

local mimixinternal = {
    __VER__ = "X-0.0.0",
    createInputElement = function(x, y, prefix)
        local text = ""
        return({
            name = "Mimix Input SVC",
            draw = function(data)
                love.graphics.print(prefix..text, x, y)
            end,
            textinput = function(key)
                text = text..key
            end,
            setText = function(t)
                text = t
            end,
            getText = function()
                return(text)
            end
        })
    end,
    cmds = {
        ls = function()
            
        end,
        lsUI = function()
            
        end,
        pls = function()
            
        end
    }
}
mimixinternal.execCMD = function(cmd)
    logger.error("NOT IMPLEMENTED YET BAKA!")
end

local mimix = {
    init = function()
        logger.info("Mimix "..mimixinternal.__VER__.." init !")
        local data = {
            input = mimixinternal.createInputElement(0, love.graphics.getHeight() - __GUIFIEDGLOBAL__.fontsize, "Mimix "..mimixinternal.__VER__.." >>> "),
            returnact = false
        }
        return({
            name = "Mimix SVC",
            draw = function()
                if data.input.id == nil then
                    guified.registry.register(data.input)
                end

                love.graphics.setColor(0, 0, 0, 0.5)
                love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

                love.graphics.setColor(1, 1, 1, 1)
            end,
            update = function(dt)
                --! BAD
                if love.keyboard.isDown("return") and not(data.returnact) then
                    data.returnact = true
                    mimixinternal.execCMD(data.input.getText())
                    data.input.setText("")
                elseif data.returnact and not(love.keyboard.isDown("return")) then
                    data.returnact = false
                end
            end
        })
    end
}

return(mimix)
