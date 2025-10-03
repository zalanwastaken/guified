-- * Type info
---@alias element table to silence warnings
---@alias image table to silence warnings

-- * functions

---@return string
local function getScriptFolder()
    return (debug.getinfo(1, "S").source:sub(2):match("(.*/)"))
end

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

local areweloaded = false

-- * setup global var
if __GUIFIEDGLOBAL__ == nil then
    ---@param str string
    ---@return string
    local function replaceSlashWithDot(str)
        return str:gsub("/", ".") -- Replace all '/' with '.'
    end

    local rootfolder = (function()
        local folder = replaceSlashWithDot(getScriptFolder())
        return (string.sub(folder, 1, #folder-1))
    end)()

    -- ? global table containing vars for guified modules
    __GUIFIEDGLOBAL__ = {
        rootfolder = rootfolder,
        fontsize = 12, -- * default font size
        os = love.system.getOS():lower(),
        __VERINT__ = "B-3.0.0", -- ! GUIFIED VERSION
        __VER__ = "B-3.0.0: Segfault Chic Edition" -- ! GUIFIED VERSION AND CODENAME
    }
    rootfolder = nil
else
    areweloaded = true
end

-- ? requires
---@type logger
local logger = require(__GUIFIEDGLOBAL__.rootfolder .. ".dependencies.logger.init") -- * logger module
coroutine.wrap((function()
    if not(logger.thread:isRunning()) and not(areweloaded) then
        logger.startSVC()
    end
end))() -- idc it works
local errorhandler = not(areweloaded) and love.filesystem.getInfo(getScriptFolder().."/errorhandler.lua") and require(__GUIFIEDGLOBAL__.rootfolder..".errorhandler") or nil --? check and load error handler

-- ? init stuff
local font
if love.filesystem.getInfo(getScriptFolder() .. "Ubuntu-L.ttf") then
    font = love.graphics.newFont(getScriptFolder() .. "Ubuntu-L.ttf", __GUIFIEDGLOBAL__.fontsize)
else
    font = love.graphics.newFont(__GUIFIEDGLOBAL__.fontsize)
end

logger.info("OS: "..love.system.getOS())
logger.info("Guified Version: "..__GUIFIEDGLOBAL__.__VER__)
logger.info("Processor Count: "..love.system.getProcessorCount())
logger.info("Guified root folder: " .. __GUIFIEDGLOBAL__.rootfolder)

love.graphics.setFont(font)
love.graphics.setColor(1, 1, 1, 1)
love.math.setRandomSeed(os.time())

if love.system.getOS():lower() == "linux" then
    --logger.warn("FFI features on Linux are not supported") --? what FFI features. I sent them to the void realm
elseif love.system.getOS():lower() == "os x" then
    logger.warn("MacOS support is experimental")
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
        elements = {
            drawstack = {},
            updatestack = {},
            textinputstack = {},
            keypressedstack = {},
            resizestack = {},
            --mousemovedstack = {}, --TODO add this
        },
        data = {},
        ids = {},

        pollingcallbackids = {},
        pollingcallbacks = {},
        callbacks = {
            keypressed = {},
            textinput = {},
            keypressedIDS = {},
            textinputIDS = {}
        },

        fclr = {1, 1, 1, 1}, -- white and opaque
        fclrenable = true
    },

    -- ? funcs

    ---@param dt number
    ---@param updatestack table
    ---@param idtbl table
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
    ---@param drawstack table
    ---@param data table
    ---@param idtbl table
    draw = function(drawstack, data, idtbl, fclr)
        for i = 1, #idtbl, 1 do
            love.graphics.setColor(fclr or {1, 1, 1, 1})
            love.graphics.setFont(__GUIFIEDGLOBAL__.font or font)
            drawstack[idtbl[i]](data[i])
        end
    end,
    ---@param key string
    ---@param textinputstack table
    ---@param idtbl table
    textinput = function(key, textinputstack, idtbl)
        for i = 1, #idtbl, 1 do
            if textinputstack[idtbl[i]] ~= nil then
                textinputstack[idtbl[i]](key)
            end
        end
    end,
    ---@param key string
    ---@param keypressedstack table
    ---@param idtbl table
    keypressed = function(key, keypressedstack, idtbl)
        for i = 1, #idtbl, 1 do
            if keypressedstack[idtbl[i]] ~= nil then
                keypressedstack[idtbl[i]](key)
            end
        end
    end,
    ---@param w number
    ---@param h number
    ---@param resizestack table
    ---@param idtbl table
    resize = function(w, h, resizestack, idtbl)
        for i = 1, #idtbl, 1 do
            if resizestack[idtbl[i]] ~= nil then
                resizestack[idtbl[i]](w, h)
            end
        end
    end,

    callbackupdate = function(idtbl, funcs)
        for i = 1, #idtbl, 1 do
            funcs[idtbl[i]]()
        end
    end,
    keypressedcallback = function(key, idtbl, funcs)
        for i = 1, #idtbl, 1 do
            funcs[idtbl[i]](key)
        end
    end,
    textinputcallback = function(key, idtbl, funcs)
        for i = 1, #idtbl, 1 do
            funcs[idtbl[i]](key)
        end
    end
}
logger.ok("setting up internal table done")

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
    ---@type elements
    elements = love.filesystem.getInfo(getScriptFolder().."elements.lua") and require(__GUIFIEDGLOBAL__.rootfolder..".elements") or nil,
    registry = {
        -- * Registers an element with the internal registry.
        -- * Validates the element's ID length, generates a unique ID, and adds it to the appropriate stacks.
        -- * Logs errors if non-function types are found for required fields.
        ---@param element element The element to register.
        ---@param id_length? number Optional length of the ID to be generated (default is 16).
        ---@return boolean Returns true on success, false on failure.
        registerOLD = function(element, id_length)
            if element ~= nil then
                logger.info("registering element "..element.name)
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
                if element.resize ~= nil then
                    if type(element.resize):lower() == "function" then
                        guifiedinternal.internalregistry.resizestack[element.id] = element.resize
                        logger.info("resize registered for element " .. element.name .. ":" .. element.id)
                    else
                        logger.error("Non-function data type in function field for resize in element " ..
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
        removeOLD = function(element)
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
                        logger.warn("Broken element ? " .. element.name .. ":" .. element.id) -- ? this will only happen in like once in a mil
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
                    if guifiedinternal.internalregistry.resizestack[element.id] ~= nil then
                        guifiedinternal.internalregistry.resizestack[element.id] = nil
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
        ---@param idlen? number
        ---@return boolean true for success, false for failure
        register = function(element, idlen)
            if not(element) then
                logger.error("No element provided to register. Aborting")
                return false
            end

            local id = idgen(idlen or 16)
            local hooks = element._guified
            for k, v in pairs(hooks) do
                if guifiedinternal.internalregistry.elements[k.."stack"] == nil then
                    if k ~= "name" and k ~= "id" then
                        logger.error("unknown hook: "..k.." in element: "..hooks.name)
                    end
                else
                    guifiedinternal.internalregistry.elements[k.."stack"][id] = v
                end
            end

            guifiedinternal.internalregistry.ids[#guifiedinternal.internalregistry.ids + 1] = id
            element._guified.id = id

            logger.info("Element "..element._guified.name..":"..element._guified.id.." registered")

            return true
        end,

        ---@param element element
        ---@return boolean
        remove = function(element)
            if element._guified.id == nil then
                logger.error("Element "..element._guified.name.." is not registed. Aborting")
                return false
            end

            table.remove(guifiedinternal.internalregistry.ids, getIndex(guifiedinternal.internalregistry.ids, element.id)) -- bye bye :)

            local hooks = element._guified
            for k, v in pairs(hooks) do
                if guifiedinternal.internalregistry.elements[k.."stack"] == nil then
                    if k ~= "name" and k ~= "id" then
                        logger.error("unknown hook: "..k.." in element: "..hooks.name)
                    end
                else
                    guifiedinternal.internalregistry.elements[k.."stack"][hooks.id] = nil
                end
            end

            element._guified.id = nil
            logger.info("Element "..element._guified.name.." removed")

            return true
        end,

        -- * checks if the element provided is registered or not
        ---@param element element
        ---@return boolean
        isRegistered = function(element)
            if element._guified.id then
                return true
            else
                return false
            end
        end,

        -- * Returns the table containing IDs for registered elements.
        ---@return table The table of IDs.
        getIdTable = function()
            return (guifiedinternal.internalregistry.ids)
        end,

        -- * registers callback and firefunc with internal registry
        ---@param firefunc function
        ---@param args table
        ---@param func function
        ---@param chkval any
        ---@param chkvaltype string equal or nequal(not equal)
        ---@return string id of registered callback
        registerPollingCallback = function(firefunc, args, func, chkval, chkvaltype)
            local id = idgen(16)
            local opr
            chkvaltype = (chkvaltype or "equal"):lower()

            logger.info("registering callback callback:"..id)

            if chkval then
                if chkvaltype == "equal" then
                    opr = function(val)
                        return chkval == val
                    end
                elseif chkvaltype == "nequal" then
                    opr = function(val)
                        return chkval ~= val
                    end
                end
            else
                opr = function(val)
                    return val ~= nil
                end
            end

            guifiedinternal.internalregistry.pollingcallbacks[id] = function()
                local k = firefunc(unpack(args, 1, #args))
                if opr(k) then
                    func(k)
                end
            end

            guifiedinternal.internalregistry.pollingcallbackids[#guifiedinternal.internalregistry.pollingcallbackids + 1] = id

            return id
        end,

        -- * removes callback and firefunc with internal registry
        ---@param id string id of registered callback
        removePollingCallback = function(id)
            logger.info("removing callback callback"..id)

            guifiedinternal.internalregistry.pollingcallbacks[id] = nil
            local idex = getIndex(guifiedinternal.internalregistry.pollingcallbackids, id)
            table.remove(guifiedinternal.internalregistry.pollingcallbackids, idex)
        end,

        -- * checks if callback is registered
        ---@param id string
        ---@return boolean
        isCallbackRegistered = function(id)
            return (getIndex(guifiedinternal.internalregistry.pollingcallbackids, id) or false) and true -- basically a if true return true if false return false
        end,

        --TODO fix this
        registerCallback = function(cbtype, run)
            local cbreg = guifiedinternal.internalregistry.callbacks[cbtype]
            if cbreg ~= nil then
                local id = idgen(16)
                guifiedinternal.internalregistry.callbacks[cbtype][id] = run
                guifiedinternal.internalregistry.callbacks[cbtype.."IDS"][#guifiedinternal.internalregistry.callbacks[cbtype.."IDS"] + 1] = id
            else
                logger.error("Attempt to register unknown callback")
            end
        end
    },

    debug = {
        -- * provided by logger module of the love2d-tools lib
        logger = logger
    },

    extcalls = {
        --* Handles draw event
        --* Calls guifiedinternal.draw
        --* draw handler
        drawf = function()
            guifiedinternal.draw(guifiedinternal.internalregistry.elements.drawstack, guifiedinternal.internalregistry.data, guifiedinternal.internalregistry.ids, guifiedinternal.internalregistry.fclrenable and guifiedinternal.internalregistry.fclr)
        end,

        --* Handles update event
        --* Calls guifiedinternal.update
        --* update handler
        updatef = function()
            guifiedinternal.callbackupdate(guifiedinternal.internalregistry.pollingcallbackids, guifiedinternal.internalregistry.pollingcallbacks)

            guifiedinternal.internalregistry.data = guifiedinternal.update(love.timer.getAverageDelta(), guifiedinternal.internalregistry.elements.updatestack,
                guifiedinternal.internalregistry.ids)
        end,

        -- * Handles text input events.
        ---@param key string The key argument from the love.textinput callback.
        -- * Passes the input to the guifiedinternal.textinput method
        -- * textinput handler
        textinputf = function(key)
            guifiedinternal.textinputcallback(key, guifiedinternal.internalregistry.callbacks.textinput, guifiedinternal.internalregistry.callbacks.keypressedIDS)
            guifiedinternal.textinput(key, guifiedinternal.internalregistry.elements.textinputstack, guifiedinternal.internalregistry.ids)
        end,

        -- * handles keypressed events
        ---@param key string The key argument from love.keypressed callback
        -- * Passes the input to the guifiedinternal.keypressed methord
        -- * keypressed handler
        keypressedf = function(key)
            guifiedinternal.keypressedcallback(key, guifiedinternal.internalregistry.callbacks.keypressedIDS, guifiedinternal.internalregistry.callbacks.keypressed)
            guifiedinternal.keypressed(key, guifiedinternal.internalregistry.elements.keypressedstack, guifiedinternal.internalregistry.ids)
        end,

        --* Handles resize event.
        ---@param w number
        ---@param h number
        --* Passes input to guifiedinternal.resize methord
        --* resize handler
        resizef = function(w, h)
            guifiedinternal.resize(w, h, guifiedinternal.internalregistry.elements.resizestack, guifiedinternal.internalregistry.ids)
        end,

        -- * Returns the current drawstack.
        ---@return table The table containing drawable elements.
        getDrawStack = function()
            return (guifiedinternal.internalregistry.drawstack)
        end,

        -- * Returns the current updatestack.
        ---@return table The table containing updateable elements.
        getUpdateStack = function()
            return (guifiedinternal.internalregistry.updatestack)
        end,

        -- * Returns the current textinputstack.
        ---@return table The table containing textinput handlers.
        getTextInputStack = function()
            return (guifiedinternal.internalregistry.textinputstack)
        end,

        -- * returns the keypressedstack
        ---@return table The table containing keypressed handlers
        getKeypressedStack = function()
            return(guifiedinternal.internalregistry.keypressedstack)
        end,

        -- * Quit function, the code that needs the be executed when the application quits
        quit = function()
            logger.regular(__GUIFIEDGLOBAL__.__VER__.." bids its farewell")
            logger.stopSVC()
            return false
        end,
    },

    funcs = {
        ---@param font string|number filepath to the font or the font size
        ---@param size? number size of the font
        updateFont = function(font, size)
            if font == nil then
                font = size
                size = nil
                logger.warn("Please use __GUIFIEDGLOBAL__.fontsize variable to set the font size insted")
            end
            __GUIFIEDGLOBAL__.font = love.graphics.newFont(font, size)
            __GUIFIEDGLOBAL__.fontsize = size or font
        end,

        setfclr = function(clr)
            guifiedinternal.internalregistry.fclr = clr or {1, 1, 1, 1}
        end,

        setfclrenable = function(enable)
            guifiedinternal.internalregistry.fclrenable = enable
        end,

        --* Sets the draw functionality
        ---@param set boolean
        setDraw = function(set)
            guifiedinternal.enabledraw = set or false
        end,

        --* Sets the update functionality
        ---@param set boolean
        setUpdate = function(set)
            guifiedinternal.enableupdate = set or false
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
    },

    properties = {
        --* Inits the property system for a element
        --! This must be run on a element before adding properties to it
        ---@param element element
        initPropertySys = function(element)
            local mt = {
                __index = {},
                __newindex = function(tbl, key, val)
                    local mt = getmetatable(tbl)
                    if mt.__index[key] then
                        mt.__index[key] = val
                        mt.funcs[key](val)
                    else
                        rawset(tbl, key, val) --? rawset so we dont cause stack overflow
                    end
                end,
                funcs = {}
            }
            setmetatable(element, mt)

            logger.info("property system init for "..element._guified.name..":"..(element._guified.id or ""))
        end,

        --* adds a property to a element
        ---@param element element
        ---@param property string
        ---@param initialVAL any
        ---@param onchange function
        newProperty = function(element, property, initialVAL, onchange)
            local mt = getmetatable(element)
            mt.__index[property] = initialVAL
            mt.funcs[property] = onchange

            logger.info("property added in element"..element._guified.name..":"..(element._guified.id or ""))
        end,

        --* returns the value of a property
        ---@param element element
        getProperty = function(element, property)
            return getmetatable(element).__index[property]
        end,

        --* returns all properties as a dict.
        ---@param element element
        getAllProperties = function(element)
            return getmetatable(element).__index
        end,

        --* removes a property from a element
        ---@param element element
        ---@param property string
        removeProperty = function(element, property)
            local mt = getmetatable(element)
            mt.__index[property] = nil
            mt.funcs[property] = nil

            logger.info("removed property from element "..element._guified.name..":"..(element._guified.id or ""))
        end,

        deInitPropertySys = function(element)
            setmetatable(element, nil) -- yeet the mt
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
        -- * guified code
        if guifiedinternal.enableupdate then
            guified.extcalls.updatef()
        end
        -- * guified code end
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
            -- * guified code
            if guifiedinternal.enabledraw then
                guified.extcalls.drawf()
            end
            -- * guified code end
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
    guified.extcalls.textinputf(key)
end
logger.ok("textinput hook setup done")

function love.keypressed(key)
    guified.extcalls.keypressedf(key)
end
logger.ok("keypressed hook setup done")

function love.resize(w, h)
    guified.extcalls.resizef(w, h)
end
logger.ok("resize hook setup done")

-- * love quit function
function love.quit()
    return guified.extcalls.quit()
end
logger.ok("Exit function setup done")

-- * post init
logger.info("Doing post init")

if love.window.getTitle():lower() == "untitled" and not(areweloaded) then
    logger.info("Window title set by guified")
    logger.warn("Window title was set by guified this disables love.window.setTitle To prevent this set window title before calling guified init")

    local setTitle = love.window.setTitle
    love.window.setTitle = nil -- kill it >:(
    setTitle("Guified: " .. __GUIFIEDGLOBAL__.__VER__)
    local title = love.window.getTitle()

    guified.registry.register({
        _guified = {
            name = "guified internal title SVC",
            draw = function()end,
            update = function()
                setTitle(title .. " FPS:" .. love.timer.getFPS())
            end
        }
    })
end

logger.ok("GUIFIED init success ! YAY!")

return guified

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
