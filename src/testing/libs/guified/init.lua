-- * Type info
---@alias element table to silence warnings
---@alias image table to silence warnings
-- * functions
---@param str string
---@return string
local function replaceSlashWithDot(str)
    return str:gsub("/", ".") -- Replace all '/' with '.'
end
---@return string
local function getScriptFolder()
    return (debug.getinfo(1, "S").source:sub(2):match("(.*/)"))
end
local areweloaded = false

-- * setup global var
if __GUIFIEDGLOBAL__ == nil then
    local function setuprootfolder()
        local folder = replaceSlashWithDot(getScriptFolder())
        return (os.getenv("GUIFIEDROOTFOLDER") or string.sub(folder, 1, #folder))
    end
    local rootfolder = setuprootfolder()
    -- ? global table containing vars for guified modules
    __GUIFIEDGLOBAL__ = {
        rootfolder = rootfolder,
        fontsize = 12, -- * default font size
        os = love.system.getOS():lower(),
        __VER__ = "B-1.1.0: Existential Crisis Edition", -- ! GUIFIED VERSION CODENAME
        __VERINT__ = "B-1.1.0" -- ! GUIFIED VERSION
    }
    rootfolder = nil
else
    areweloaded = true
end

-- ? requires
local OSinterop
if not (areweloaded) then
    if love.filesystem.getInfo(getScriptFolder() .. "/os_interop.lua") then
        OSinterop = require(__GUIFIEDGLOBAL__.rootfolder .. ".os_interop") -- ? contains ffi 
    end
    if love.filesystem.getInfo(getScriptFolder() .. "/errorhandler.lua") then
        require(__GUIFIEDGLOBAL__.rootfolder .. ".errorhandler") -- * setup errorhandler
    end
end
---@type logger
local logger = require(__GUIFIEDGLOBAL__.rootfolder .. ".dependencies.love2d-tools.modules.logger.init") -- * logger module
if not (logger.thread:isRunning()) and not (areweloaded) then
    logger.startSVC()
end

-- ? init stuff
local font
if love.filesystem.getInfo(getScriptFolder() .. "Ubuntu-L.ttf") then
    font = love.graphics.newFont(getScriptFolder() .. "Ubuntu-L.ttf", __GUIFIEDGLOBAL__.fontsize)
else
    font = love.graphics.newFont(__GUIFIEDGLOBAL__.fontsize)
end

logger.ok("Got guified root folder " .. __GUIFIEDGLOBAL__.rootfolder)

love.graphics.setFont(font)
love.graphics.setColor(1, 1, 1, 1)
love.math.setRandomSeed(os.time())

if love.system.getOS():lower() == "linux" then
    -- logger.warn("Features that use FFI will not work on Linux !")
elseif love.system.getOS():lower() == "macos" then
    -- ? If apple was not such a ass and let us run macOS on a vm this would have been supported
    -- ? Like why even lock down something that much ? Too much effort according to me
    -- ? Trust me i tired to run macOS on a vm but it just would not work. And im not buying a expensive piece of garbage computer
    logger.warn("MacOS is not suppoorted !\nUse at your own caution")
end

if os.getenv("GUIFIEDROOTFOLDER") == nil then
    logger.warn("ENV VAR GUIFIEDROOTFOLDER IS NOT SETUP ! This may cause issues")
end
logger.ok("init setup done")

if areweloaded then
    logger.error("Guified init was called a second time !")
else
    __GUIFIEDGLOBAL__.font = font
end

-- * Guified code

-- * internal stuff
---@class guifiedinternal
local guifiedinternal = {
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
        ---@class keypressedstack
        keypressedstack = {},
        ---@class dataholder
        data = {},
        ---@class idholder
        ids = {}
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
    draw = function(drawstack, data, idtbl)
        for i = 1, #idtbl, 1 do
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.setFont(font)
            drawstack[idtbl[i]](data[i])
        end
    end,
    textinput = function(key, textinputstack, idtbl)
        for i = 1, #idtbl, 1 do
            if textinputstack[idtbl[i]] ~= nil then
                textinputstack[idtbl[i]](key)
            end
        end
    end,
    keypressed = function(key, keypressedstack, idtbl)
        for i = 1, #idtbl, 1 do
            if keypressedstack[idtbl[i]] ~= nil then
                keypressedstack[idtbl[i]](key)
            end
        end
    end
}
logger.ok("setting up internal table done")

-- * funcs
-- ? they need guified stuff so declared here

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
    local chars = {
        -- * Small chars
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w",
        "x", "y", "z", 
        -- * Capital chars
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W",
        "X", "Y", "Z", 
        -- * Numbers
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", 
        -- * Special chars
        "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_", "=", "+", "{", "}", "[", "]", ":", ";", "'", "<", ">",
        ",", ".", "?", "/"
    }
    local ret = ""
    for i = 1, length, 1 do
        ret = ret .. chars[love.math.random(1, #chars)]
    end
    return (ret)
end
local function mergetables(t1, t2)
    for k, v in pairs(t2) do
        t1[k] = v
    end
    return t1
end
---@return elements
local function loadelements()
    if love.filesystem.getInfo(getScriptFolder() .. "/elements.lua") then
        return (require(__GUIFIEDGLOBAL__.rootfolder .. ".elements"))
    else
        return nil
    end
end

-- * guified return table
---@class guified
local guified = {
    -- * version licence author stuff
    __VER__ = __GUIFIEDGLOBAL__.__VER__,
    __VERINT__ = __GUIFIEDGLOBAL__.__VERINT__,
    __LICENCE__ = [[
Copyright (c) 2024 Zalanwastaken(Mudit Mishra)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

1. Redistributions of source code must retain the above copyright notice, this list of conditions, and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions, and the following disclaimer in the documentation and/or other materials provided with the distribution.
3. Neither the name of the authors nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]],
    __AUTHOR__ = "Zalanwastaken",

    -- * actual guified stuff

    -- * Contains the element constructor functions
    elements = loadelements(),
    registry = {
        -- * Registers an element with the internal registry.
        -- * Validates the element's ID length, generates a unique ID, and adds it to the appropriate stacks.
        -- * Logs errors if non-function types are found for required fields.
        ---@param element element The element to register.
        ---@param id_length number Optional length of the ID to be generated (default is 16).
        ---@return boolean Returns true on success, false on failure.
        register = function(element, id_length)
            if element ~= nil then
                if element.name == nil then
                    logger.error("Element name missing. Aborting")
                    return (false)
                end
                if id_length or 16 < 6 then
                    warnf("ID REG for " .. element.name .. " is too short")
                end
                local id = idgen(id_length or 16)
                for i = 1, #guifiedinternal.internalregistry.ids, 1 do
                    if id == guifiedinternal.internalregistry.ids[i] then
                        logger.error("Failed to register element " .. element.name .. " ID already exists. Aborting")
                        return (false)
                    end
                end
                element.id = id
                id = nil
                guifiedinternal.internalregistry.ids[#guifiedinternal.internalregistry.ids + 1] = element.id
                if type(element.draw):lower() == "function" then
                    guifiedinternal.internalregistry.drawstack[element.id] = element.draw
                    logger.info("draw registered for element " .. element.name .. ":" .. element.id)
                else
                    logger.error("Non-function data type in function field for draw in element " .. element.name)
                    logger.error("Critical element function draw missing. Registering element " .. element.name ..
                                     " failed. Aborting")
                    return (false)
                end
                if element.update ~= nil then
                    if type(element.update):lower() == "function" then
                        guifiedinternal.internalregistry.updatestack[element.id] = element.update
                        logger.info("update registered for element " .. element.name .. ":" .. element.id)
                    else
                        logger.error("Non-function data type in function field for update in element " .. element.name)
                    end
                end
                if element.textinput ~= nil then
                    if type(element.textinput):lower() == "function" then
                        guifiedinternal.internalregistry.textinputstack[element.id] = element.textinput
                        logger.info("textinput registered for element " .. element.name .. ":" .. element.id)
                    else
                        logger.error("Non-function data type in function field for textinput in element " ..
                                         element.name)
                    end
                end
                if element.keypressed ~= nil then
                    if type(element.keypressed):lower() == "function" then
                        guifiedinternal.internalregistry.keypressedstack[element.id] = element.keypressed
                        logger.info("keypressed registered for element " .. element.name .. ":" .. element.id)
                    else
                        logger.error("Non-function data type in function field for keypressed in element " ..
                                         element.name)
                    end
                end
                return (true)
            else
                logger.error("No element provided to register. Aborting")
                return (false)
            end
        end,

        -- * Removes an element from the internal registry.
        -- * Supports removing by element object or ID (using ID is discouraged).
        -- * Cleans up the element from all relevant stacks and logs the action.
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
                    logger.warn("Using a ID to remove a element is not recommended. Warning for: " .. element.name)
                end
                if element.id ~= nil then
                    local idindex = getIndex(guifiedinternal.internalregistry.ids, element.id)
                    if guifiedinternal.internalregistry.drawstack[element.id] ~= nil then
                        guifiedinternal.internalregistry.drawstack[element.id] = nil
                    else
                        logger.warn("Broken element ? NAME:" .. element.name .. ":" .. element.id) -- ? this will only happen in like once in a mil
                    end
                    if guifiedinternal.internalregistry.updatestack[element.id] ~= nil then
                        guifiedinternal.internalregistry.updatestack[element.id] = nil
                    end
                    if guifiedinternal.internalregistry.textinputstack[element.id] ~= nil then
                        guifiedinternal.internalregistry.textinputstack[element.id] = nil
                    end
                    if guifiedinternal.internalregistry.keypressedstack[element.id] ~= nil then
                        guifiedinternal.internalregistry.keypressedstack[element.id] = nil
                    end
                    table.remove(guifiedinternal.internalregistry.ids, idindex)
                    idindex = nil
                    logger.info("Removing element " .. element.name .. ":" .. element.id)
                    element.id = nil
                    return (true)
                else
                    logger.error("Element " .. element.name .. " is not registed. Aborting")
                    return (false)
                end
            else
                logger.error("No element provided to remove. Aborting")
                return (false)
            end
        end,

        ---@param element element
        ---@param event string
        ---@param func function
        injectEventHandler = function(element, event, func)
            error("NON FUNCTIONAL DO NOT USE") --! disabled for now
            if element.id ~= nil then --? there will be a element id if the element is registered
                if element.__events == nil then
                    logger.error("element "..element.name..":"..element.id.." does not support events")
                else
                    if element.__events[event] then
                        element.__eventcalls[event] = func
                    end
                end
            else
                logger.error("element "..element.name.." is not registered")
            end
        end,
        
        ---@param element element
        ---@param event string
        removeEventHandler = function(element, event)
            error("NON FUNCTIONAL DO NOT USE") --! disabled for now
            if element.__eventcalls[event] ~= nil then
                element.__eventcalls[event] = nil
            else
                logger.error(event.." is not set in "..element.name..":"..(element.id or "err"))
            end
        end
    },

    debug = {
        -- ! more stuff is added in post init

        -- * provided by logger module of the love2d-tools lib
        ---@type logger
        logger = logger
    },

    extcalls = {
        -- * Draw function that manages rendering.
        -- * Calls the guifiedinternal.draw method to process all drawable elements
        -- * from the drawstack in the internal registry.
        drawf = function()
            guifiedinternal.draw(guifiedinternal.internalregistry.drawstack, guifiedinternal.internalregistry.data)
        end,

        -- * Update function that manages updating.
        -- * Calls the guifiedinternal.update method with the average delta time and
        -- * processes elements from the updatestack and associated ids in the internal registry.
        updatef = function()
            guifiedinternal.update(love.timer.getAverageDelta(), guifiedinternal.internalregistry.updatestack,
                guifiedinternal.internalregistry.ids)
        end,

        -- * Handles text input events.
        ---@param key string The key argument from the love.textinput callback.
        -- * Passes the input to the guifiedinternal.textinput method
        -- * textinput handler
        textinputf = function(key)
            guifiedinternal.textinput(key, guifiedinternal.internalregistry.textinputstack,
                guifiedinternal.internalregistry.ids)
        end,

        -- * handles keypressed events
        ---@param key string The key argument from love.keypressed callback
        -- * Passes the input to the guifiedinternal.keypressed methord
        -- * keypressed handler
        keypressedf = function(key)
            guifiedinternal.textinput(key, guifiedinternal.internalregistry.keypressedstack, guifiedinternal.internalregistry.ids)
        end,

        -- * Returns the current drawstack.
        ---@return drawstack The table containing drawable elements.
        getDrawStack = function()
            return (guifiedinternal.internalregistry.drawstack)
        end,

        -- * Returns the current updatestack.
        ---@return updatestack The table containing updateable elements.
        getUpdateStack = function()
            return (guifiedinternal.internalregistry.updatestack)
        end,

        -- * Returns the current textinputstack.
        ---@return textinputstack The table containing textinput handlers.
        getTextInputStack = function()
            return (guifiedinternal.internalregistry.textinputstack)
        end,

        -- * returns the keypressedstack
        ---@return keypressedstack The table containing keypressed handlers
        getKeypressedStack = function()
            return(guifiedinternal.internalregistry.keypressedstack)
        end,

        -- * Quit function the code that needs the be executed when the application quits
        quit = function()
            logger.stopSVC()
        end
    },

    funcs = {
        -- * Sets the window to always be on top.
        setWindowToBeOnTop = function()
            guifiedinternal.setWindowToBeOnTop(love.window.getTitle())
        end,
        -- * Toggles the draw functionality on or off.
        toggleDraw = function()
            guifiedinternal.enabledraw = not (guifiedinternal.enabledraw)
        end,
        -- * Toggles the update functionality on or off.
        toggleUpdate = function()
            guifiedinternal.enableupdate = not (guifiedinternal.enableupdate)
        end,
        -- * Returns the current draw status.
        ---@return boolean True if drawing is enabled, false otherwise.
        getDrawStatus = function()
            return (guifiedinternal.enabledraw)
        end,
        -- * Returns the current update status.
        ---@return boolean True if updating is enabled, false otherwise.
        getUpdateStatus = function()
            return (guifiedinternal.enableupdate)
        end,
        -- * Returns the table containing IDs for registered elements.
        ---@return table The table of IDs.
        getIdTable = function()
            return (guifiedinternal.internalregistry.ids)
        end,
        -- * Returns the current font size.
        -- ! This function is deprecated use `__GUIFIEDGLOBAL__.fontsize` variable insted
        ---@deprecated
        ---@return number The size of the font.
        getFontSize = function()
            return (__GUIFIEDGLOBAL__.fontsize)
        end,
        -- * Sets a new font size.
        -- ! This function is deprecated use `__GUIFIEDGLOBAL__.fontsize` variable insted
        ---@deprecated
        ---@param size number The new font size to be set.
        setFontSize = function(size)
            __GUIFIEDGLOBAL__.fontsize = size
        end,
        -- * checks if the element provided is registered or not
        ---@param element element
        ---@return boolean
        isRegistered = function(element)
            if element.id then
                return true
            else
                return false
            end
        end,

        ---@param font string filepath to the font
        ---@param size number size of the font
        updateFont = function(font, size)
            if font == nil then
                font = size
                size = nil
            end
            __GUIFIEDGLOBAL__.font = love.graphics.newFont(font, size)
            __GUIFIEDGLOBAL__.fontsize = size or font
        end
    }
}
logger.ok("setting up main return table done")

-- * Love functions

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
        if guifiedinternal.update and guifiedinternal.enableupdate then
            guifiedinternal.internalregistry.data = guifiedinternal.update(dt, guifiedinternal.internalregistry
                .updatestack, guifiedinternal.internalregistry.ids)
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
            if guifiedinternal.draw and guifiedinternal.enabledraw then
                guifiedinternal.draw(guifiedinternal.internalregistry.drawstack, guifiedinternal.internalregistry.data,
                    guifiedinternal.internalregistry.ids)
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
    guifiedinternal.textinput(key, guifiedinternal.internalregistry.textinputstack, guifiedinternal.internalregistry.ids)
end
logger.ok("textinput hook setup done")

function love.keypressed(key)
    guifiedinternal.keypressed(key, guifiedinternal.internalregistry.keypressedstack,
        guifiedinternal.internalregistry.ids)
end
logger.ok("keypressed hook setup done")

-- * love quit function
function love.quit()
    guified.extcalls.quit()
    return (false)
end
logger.ok("Exit function setup done")

-- * post init
logger.info("Doing post init")

if not (areweloaded) and OSinterop ~= nil then
    guifiedinternal.setWindowToBeOnTop = OSinterop(logger.warn).setWindowToBeOnTop -- ? requires ffi so added by OSinterop here after (almost) everything is done
end
guifiedinternal.internalregistry.warndata = {}

---@deprecated
--! this function will be removed
-- * puts a warning on the screen and logs it
---@param warning string
guified.debug.warn = function(warning)
    logger.warn(warning)
    warning = "[wARNING] " .. warning
    guifiedinternal.internalregistry.warndata[#guifiedinternal.internalregistry.warndata + 1] = warning
    local ourpos = #guifiedinternal.internalregistry.warndata
    guified.registry.register({
        name = "Guified warning",
        draw = function()
            love.graphics.setColor(1, 0, 0)
            love.graphics.print(warning, 0, ((ourpos - 1) * 12) + 2)
        end
    })
end

---@deprecated
--! this function will be removed
-- * puts a error on the screen and logs it
---@param err string
guified.debug.error = function(err)
    logger.error(err)
    err = "[ERROR] " .. err
    guifiedinternal.internalregistry.warndata[#guifiedinternal.internalregistry.warndata + 1] = err
    local ourpos = #guifiedinternal.internalregistry.warndata
    guified.registry.register({
        name = "Guified error",
        draw = function()
            love.graphics.setColor(1, 0, 0)
            love.graphics.print(err, 0, ((ourpos - 1) * 12) + 2)
        end
    })
end

if love.window.getTitle():lower() == "untitled" and not(areweloaded) then
    logger.info("Window title set by guified")
    logger.warn("Window title was set by guified this disables love.window.setTitle. To prevent this set window title before calling guified init")
    local setTitle = love.window.setTitle
    love.window.setTitle = nil
    setTitle("Guified: " .. __GUIFIEDGLOBAL__.__VER__)
    local title = love.window.getTitle()
    guified.registry.register({
        name = "guified internal title SVC",
        draw = function()
        end,
        update = function()
            setTitle(title .. " FPS:" .. love.timer.getFPS())
        end
    })
end

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
