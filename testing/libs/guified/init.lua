-- * Type info
---@alias element table to silence warnings
---@alias image table to silence warnings

-- ? config
local fontsize = 12 -- * default font size
--local VK_CAPITAL = 0x14 -- * Virtual-Key Code for Caps Lock

-- ? imp funcs
---@param str string
---@return string
local function replaceSlashWithDot(str)
    return str:gsub("/", ".")  -- Replace all '/' with '.'
end
---@return string
local function getScriptFolder()
    return (debug.getinfo(1, "S").source:sub(2):match("(.*/)"))
end

-- ? requires
local ffi = require("ffi")
local OSinterop = require("libs.guified.os_interop") -- ? contains ffi now
require("libs.guified.errorhandler") -- * setup errorhandler
local messagebus = require("libs.guified.dependencies.love2d-tools.modules.messagebus") --* message_bus
local logger = require("libs.guified.dependencies.love2d-tools.modules.logger.init") --* logger module
--local state = require("libs.guified.dependencies.love2d-tools.modules.state") --* state machine

-- ? init stuff
local font = love.graphics.newFont(getScriptFolder() .. "Ubuntu-L.ttf")
__GUIFIEDGLOBAL__ = {
    rootfolder = replaceSlashWithDot(getScriptFolder())
}
love.graphics.setFont(font, fontsize)
love.graphics.setColor(1, 1, 1, 1)
love.math.setRandomSeed(os.time())
if love.system.getOS():lower() == "linux" then
    logger.warn("Features that use FFI will not work on Linux !")
elseif love.system.getOS():lower() == "macos" then
    --? If apple was not such a ass and let us run macOS on a vm this would have been supported
    --? Like why even lock down something that much ? Too much effort according to me
    --? Trust me i tired to run macOS on a vm but it just would not work. And im not buying a expensive piece of garbage computer
    logger.warn("MacOS is not suppoorted !\nUse at your own caution")
end
logger.startSVC()
logger.ok("Got guified root folder "..__GUIFIEDGLOBAL__.rootfolder)
logger.ok("init setup done")

-- * internal stuff
local guifiedlocal = {
    -- ? vars
    enableupdate = true,
    enabledraw = true,

    ---@class internalregistry
    internalregistry = {
        ---@class drawstack
        drawstack = {},
        ---@class updatestack
        updatestack = {},
        ---@class textinputstack
        textinputstack = {},
        ---@class dataholder
        data = {},
        ---@class idholder
        ids = {},
        ---@class warningholder
        warns = {},
        --optional = true
    },

    -- ? funcs

    ---@param dt number
    ---@param updatestack updatestack
    ---@return table returns the data prossesed by the updatestack
    update = function(dt, updatestack, idtbl)
        local data = {}
        for i = 1, #idtbl, 1 do
            if updatestack[idtbl[i]] ~= nil then
                data[i] = updatestack[idtbl[i]](dt)
            end
        end
        return (data)
    end,
    ---@param drawstack drawstack
    ---@param data table
    draw = function(drawstack, data)
        for i = 1, #drawstack, 1 do
            love.graphics.setColor(1, 1, 1, 1)
            drawstack[i](data[i]) -- ? call the draw func
        end
    end,
    textinput = function(key, textinputstack, idtbl)
        for i = 1, #idtbl, 1 do
            if textinputstack[idtbl[i]] ~= nil then
                textinputstack[idtbl[i]](key)
            end
        end
    end
}
logger.ok("setting up internal table done")

-- * funcs

---@param warn string
local function warnf(warn)
    guifiedlocal.internalregistry.warns[#guifiedlocal.internalregistry.warns + 1] = "[WARNING] " .. warn
    logger.warn(warn)
end
--[[
---@return boolean
local function isCapsLockOn()
    -- GetKeyState returns a value where the lowest bit indicates the key's toggle state.
    local state = ffi.C.GetKeyState(VK_CAPITAL)
    return state ~= 0 and bit.band(state, 0x0001) ~= 0
end
--]]
---@return number|nil
local function getIndex(table, val)
    for i = 1, #table, 1 do
        if table[i] == val then
            return (i)
        end
    end
    return (nil)
end
---@param length number
---@return string
local function idgen(length)
    length = length or 16
    local chars = { -- * Small chars
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w",
    "x", "y", "z", -- * Capital chars
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W",
    "X", "Y", "Z", -- * Numbers
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", -- * Special chars
    "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_", "=", "+", "{", "}", "[", "]", ":", ";", "'", "<", ">",
    ",", ".", "?", "/"}
    local ret = ""
    for i = 1, length, 1 do
        ret = ret .. chars[love.math.random(1, #chars)]
    end
    return (ret)
end

-- ? guified return table
local guified = {
    __VER__ = "A-1.2.2", -- ? The version of Guified bruh
    __LICENCE__ = [[
Copyright (c) 2024 Zalanwastaken(Mudit Mishra)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

1. Redistributions of source code must retain the above copyright notice, this list of conditions, and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions, and the following disclaimer in the documentation and/or other materials provided with the distribution.
3. Neither the name of the authors nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]],
    __AUTHOR__ = "Zalanwastaken",
    registry = {
        -- * Contains the element constructor functions
        elements = {
            button = {
                ---@param argtext string
                ---@param argx number
                ---@param argy number
                ---@param h number optional since A-1.2.0
                ---@param w number optional since A-1.2.0
                ---@return element
                new = function(self, argx, argy, argtext, w, h)
                    local isPressed = false -- Track if the button is currently pressed
                    local autoctl = true
                    if w ~= nil and h ~= nil then
                        autoctl = false
                    end
                    return ({
                        name = "button",
                        draw = function()
                            if autoctl then
                                -- Adjust button size to fit text
                                local charWidth = fontsize / 2 -- Approx width of each character in a monospace font
                                w = #argtext * charWidth + 20 -- Add padding to the width
                                h = fontsize + 10 -- Set height based on font size with padding
                                love.graphics.print(argtext, argx + (w / 2) - (#argtext * charWidth / 2),
                                    argy + (h / 2) - (fontsize / 2))
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
                        y = argy - (h / 2 - fontsize)
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
                        end
                    })
                end
            },

            image = {
                ---@param x number
                ---@param y number
                ---@param image image
                new = function(self, x, y, image)
                    return ({
                        name = "image",
                        draw = function()
                            love.graphics.draw(image, x, y)
                        end,
                        changePos = function(argx, argy)
                            x = argx
                            y = argy
                        end
                    })
                end
            }
        },
        --* Registers an element with the internal registry.
        --* Validates the element's ID length, generates a unique ID, and adds it to the appropriate stacks.
        --* Logs errors if non-function types are found for required fields.
        ---@param element element The element to register.
        ---@param id_length number Optional length of the ID to be generated (default is 16).
        ---@return boolean Returns true on success, false on failure.
        register = function(element, id_length)
            if element ~= nil then
                if element.name == nil then
                    logger.error("Element name missing. Aborting")
                    return(false)
                end
                if id_length or 16 < 6 then
                    warnf("ID REG for " .. element.name .. " is too short")
                end
                local place = #guifiedlocal.internalregistry.drawstack + 1
                local id = idgen(id_length or 16)
                for i = 1, #guifiedlocal.internalregistry.ids, 1 do
                    if id == guifiedlocal.internalregistry.ids[i] then
                        logger.error("Failed to register element " .. element.name .. " ID already exists. Aborting")
                        return (false)
                    end
                end
                element.id = id
                guifiedlocal.internalregistry.ids[place] = element.id
                if type(element.draw):lower() == "function" then
                    guifiedlocal.internalregistry.drawstack[#guifiedlocal.internalregistry.drawstack + 1] = element.draw
                else
                    logger.error("Non-function data type in function field for draw in element "..element.name)
                    logger.error("Critical element function draw missing. Registering element "..element.name.." failed. Aborting")
                    return(false)
                end
                if element.update ~= nil then
                    if type(element.update):lower() == "function" then
                        guifiedlocal.internalregistry.updatestack[element.id] = element.update
                        logger.info("element " .. element.name .. " update registered ID: " .. element.id)
                    else
                        logger.error("Non-function data type in function field for update in element "..element.name)
                    end
                end
                if element.textinput ~= nil then
                    if type(element.textinput):lower() == "function" then
                        guifiedlocal.internalregistry.textinputstack[element.id] = element.textinput
                        logger.info("element " .. element.name .. " textinput registered ID: " .. element.id)
                    else
                        logger.error("Non-function data type in function field for textinput in element "..element.name)
                    end
                end
                logger.info("element " .. element.name .. " draw registered ID: " .. element.id)
                return(true)
            else
                logger.error("No element provided to register. Aborting")
                return(false)
            end
        end,

        --* Removes an element from the internal registry.
        --* Supports removing by element object or ID (using ID is discouraged).
        --* Cleans up the element from all relevant stacks and logs the action.
        ---@param element element The element or its ID to remove.
        ---@return boolean Returns true on success, false on failure.
        remove = function(element)
            if element ~= nil then
                if type(element) == "string" then
                    local id = element
                    element = {
                        name = id,
                        id = id
                    }
                    warnf("USING A ID TO REMOVE A ELEMENT IS NOT RECOMENED")
                end
                if element.id ~= nil then
                    local place = getIndex(guifiedlocal.internalregistry.ids, element.id)
                    table.remove(guifiedlocal.internalregistry.drawstack, place)
                    if guifiedlocal.internalregistry.updatestack[element.id] ~= nil then
                        guifiedlocal.internalregistry.updatestack[element.id] = nil
                    end
                    if guifiedlocal.internalregistry.textinputstack[element.id] ~= nil then
                        guifiedlocal.internalregistry.textinputstack[element.id] = nil
                    end
                    table.remove(guifiedlocal.internalregistry.ids, place)
                    logger.info("element " .. element.name .. " removed ID: " .. element.id)
                    element.id = nil
                    return(true)
                else
                    logger.error("Element " .. element.name .. " is not registed. Aborting")
                    return(false)
                end
            else
                logger.error("No element provided to remove. Aborting")
                return(false)
            end
        end
    },

    debug = {
        --* Logs a warning message using warnf.
        warn = warnf,
        --* provided by logger module of the love2d-tools lib
        logger = logger
    },

    extcalls = {
        -- * Draw function that manages rendering.
        -- * Calls the guifiedlocal.draw method to process all drawable elements
        -- * from the drawstack in the internal registry.
        drawf = function()
            guifiedlocal.draw(guifiedlocal.internalregistry.drawstack, guifiedlocal.internalregistry.data)
        end,
        -- * Update function that manages updating.
        -- * Calls the guifiedlocal.update method with the average delta time and
        -- * processes elements from the updatestack and associated ids in the internal registry.
        updatef = function()
            guifiedlocal.update(love.timer.getAverageDelta(), guifiedlocal.internalregistry.updatestack, guifiedlocal.internalregistry.ids)
        end,
        -- * Handles text input events.
        ---@param key string The key argument from the love.textinput callback.
        -- * Passes the input to the guifiedlocal.textinput method, which processes
        -- * text input handlers from the textinputstack in the internal registry.
        textinputf = function(key)
            guifiedlocal.textinput(key, guifiedlocal.internalregistry.textinputstack, guifiedlocal.internalregistry.ids)
        end,
        -- * Returns the current drawstack.
        ---@return drawstack The table containing drawable elements.
        getDrawStack = function()
            return (guifiedlocal.internalregistry.drawstack)
        end,
        -- * Returns the current updatestack.
        ---@return updatestack The table containing updateable elements.
        getUpdateStack = function()
            return (guifiedlocal.internalregistry.updatestack)
        end,
        -- * Returns the current textinputstack.
        ---@return textinputstack The table containing text input handlers.
        getTextIInputStack = function()
            return (guifiedlocal.internalregistry.textinputstack)
        end,
        quit = function()
            logger.stopSVC()
        end
    },

    funcs = {
        -- * Sets the window to always be on top.
        setWindowToBeOnTop = function()
            guifiedlocal.setWindowToBeOnTop(love.window.getTitle())
        end,
        -- * Toggles the draw functionality on or off.
        toggleDraw = function()
            guifiedlocal.enabledraw = not (guifiedlocal.enabledraw)
        end,
        -- * Toggles the update functionality on or off.
        toggleUpdate = function()
            guifiedlocal.enableupdate = not (guifiedlocal.enableupdate)
        end,
        -- * Returns the current draw status.
        ---@return boolean True if drawing is enabled, false otherwise.
        getDrawStatus = function()
            return (guifiedlocal.enabledraw)
        end,
        -- * Returns the current update status.
        ---@return boolean True if updating is enabled, false otherwise.
        getUpdateStatus = function()
            return (guifiedlocal.enableupdate)
        end,
        -- * Returns the table containing IDs for registered elements.
        ---@return table The table of IDs.
        getIdTable = function()
            return (guifiedlocal.internalregistry.ids)
        end,
        -- * Returns the current font size.
        ---@return number The size of the font.
        getFontSize = function()
            return (fontsize)
        end,
        -- * Sets a new font size.
        ---@param size number The new font size to be set.
        setFontSize = function(size)
            fontsize = size
        end
    }
}
logger.ok("setting up main return table done")

-- ? Love functions

-- * main love loop
function love.run()
    if love.load then
        love.load(love.arg.parseGameArguments(arg), arg)
    end
    -- * We don't want the first frame's dt to include time taken by love.load.
    if love.timer then
        love.timer.step()
    end
    local dt = 0
    -- * Main loop time.
    return function()
        -- * Process events.
        if love.event then
            love.event.pump()
            for name, a, b, c, d, e, f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return a or 0
                    end
                end
                love.handlers[name](a, b, c, d, e, f)
            end
        end
        -- * Update dt, as we'll be passing it to update
        if love.timer then
            dt = love.timer.step()
        end
        -- ? guified code
        if guifiedlocal.update and guifiedlocal.enableupdate then
            guifiedlocal.internalregistry.data = guifiedlocal.update(dt, guifiedlocal.internalregistry.updatestack,
                guifiedlocal.internalregistry.ids)
        end
        -- ? guified code end
        -- Call update and draw
        if love.update then
            love.update(dt)
        end -- will pass 0 if love.timer is disabled
        if love.graphics and love.graphics.isActive() then
            love.graphics.origin()
            love.graphics.clear(love.graphics.getBackgroundColor())
            if love.draw then
                love.draw()
            end
            -- ? guified code
            if guifiedlocal.draw and guifiedlocal.enabledraw then
                guifiedlocal.draw(guifiedlocal.internalregistry.drawstack, guifiedlocal.internalregistry.data)
            end
            -- ? guified code end
            love.graphics.present()
        end
        if love.timer then
            love.timer.sleep(0.001)
        end
    end
end
logger.ok("main loop setup done")

-- * textinput event function
---@param key any
function love.textinput(key)
    guifiedlocal.textinput(key, guifiedlocal.internalregistry.textinputstack, guifiedlocal.internalregistry.ids)
end
logger.ok("setting up textinput hook done")

--* love quit function
function love.quit()
    guified.extcalls.quit()
    return(false)
end
logger.ok("exit function setup done")

-- * post init

guifiedlocal.setWindowToBeOnTop = OSinterop(warnf).setWindowToBeOnTop -- ? requires ffi so added by OSinterop here after (almost) everything is done

-- * SVC init

-- ? The WARN SVC
-- * Processes warnings and displays them
-- TODO rework this in A-1.3.0
guified.registry.register({
    name = "warnSVC Guified internal",
    draw = function()
    end,
    update = function()
        for i = 1, #guifiedlocal.internalregistry.warns, 1 do
            local warnelement = guified.registry.elements.text:new(0, love.graphics.getHeight() -
                ((i * fontsize * 2) - #guifiedlocal.internalregistry.warns), guifiedlocal.internalregistry.warns[i])
            warnelement.name = "warnSVC Guified internal warning"
            guified.registry.register(warnelement)
            guifiedlocal.internalregistry.warns[i] = nil
        end
    end
})
logger.ok("GUIFIED init success !")
return (guified)

--[[
* Made by Zalanwastaken with LÖVE and some 🎔
! ________  ________  ___       ________  ________   ___       __   ________  ________  _________  ________  ___  __    _______   ________      
!|\_____  \|\   __  \|\  \     |\   __  \|\   ___  \|\  \     |\  \|\   __  \|\   ____\|\___   ___\\   __  \|\  \|\  \ |\  ___ \ |\   ___  \    
! \|___/  /\ \  \|\  \ \  \    \ \  \|\  \ \  \\ \  \ \  \    \ \  \ \  \|\  \ \  \___|\|___ \  \_\ \  \|\  \ \  \/  /|\ \   __/|\ \  \\ \  \   
!     /  / /\ \   __  \ \  \    \ \   __  \ \  \\ \  \ \  \  __\ \  \ \   __  \ \_____  \   \ \  \ \ \   __  \ \   ___  \ \  \_|/_\ \  \\ \  \  
!    /  /_/__\ \  \ \  \ \  \____\ \  \ \  \ \  \\ \  \ \  \|\__\_\  \ \  \ \  \|____|\  \   \ \  \ \ \  \ \  \ \  \\ \  \ \  \_|\ \ \  \\ \  \ 
!   |\________\ \__\ \__\ \_______\ \__\ \__\ \__\\ \__\ \____________\ \__\ \__\____\_\  \   \ \__\ \ \__\ \__\ \__\\ \__\ \_______\ \__\\ \__\
!    \|_______|\|__|\|__|\|_______|\|__|\|__|\|__| \|__|\|____________|\|__|\|__|\_________\   \|__|  \|__|\|__|\|__| \|__|\|_______|\|__| \|__|
!                                                                                \|_________|                                                   
--]]
