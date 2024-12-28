--* Type info
---@alias element table
---@alias image table to silence warnings
--? config
local fontsize = 12 --* default font size
local VK_CAPITAL = 0x14 --* Virtual-Key Code for Caps Lock
local WARN = true --* Enable warnings ?
--? requires
local ffi = require("ffi")
local OSinterop = require("libs.guified.os_interop") --? contains ffi now
require("libs.guified.errorhandler") --* setup errorhandler
--? imp funcs
---@return string
local function getScriptFolder()
    return(debug.getinfo(1, "S").source:sub(2):match("(.*/)"))
end
--? init stuff
local font = love.graphics.newFont(getScriptFolder().."Ubuntu-L.ttf")
love.graphics.setFont(font, fontsize)
love.graphics.setColor(1, 1, 1, 1)
love.math.setRandomSeed(os.time())
if WARN then
    if love.system.getOS():lower() == "linux" then
        love.window.showMessageBox("Warning", "Features that use FFI will not work on Linux !", "warning")
    end
    if love.system.getOS():lower() == "macos" then
        love.window.showMessageBox("Warning", "MacOS is not suppoorted !", "warning")
    end
end
--? local stuff
local guifiedlocal = {
    --? vars
    enableupdate = true,
    enabledraw = true,
    internalregistry = {
        ---@class drawstack
        drawstack = {},
        ---@class updatestack
        updatestack = {},
        data = {},
        ids = {},
        warns = {}
    },
    --?funcs
    ---@param dt number
    ---@param updatestack updatestack
    ---@return table returns the data prossesed by the updatestack
    update = function(dt, updatestack, idtbl)
        local data = {}
        for i = 1, #idtbl, 1 do
            --print(i, #updatestack)
            if updatestack[idtbl[i]] ~= nil then
                data[i] = updatestack[idtbl[i]](dt)
            end
        end
        return(data)
    end,
    ---@param drawstack drawstack
    ---@param data table
    draw = function(drawstack, data)
        for i = 1, #drawstack, 1 do
            love.graphics.setColor(1, 1, 1, 1)
            drawstack[i](data[i]) --? call the draw func
        end
    end
}
--* funcs
local function warnf(warn)
    guifiedlocal.internalregistry.warns[#guifiedlocal.internalregistry.warns + 1] = warn
end
---@return boolean
local function isCapsLockOn()
    -- GetKeyState returns a value where the lowest bit indicates the key's toggle state.
    local state = ffi.C.GetKeyState(VK_CAPITAL)
    return state ~= 0 and bit.band(state, 0x0001) ~= 0
end
---@return number|nil
local function getIndex(table, val)
    for i = 1, #table, 1 do
        if table[i] == val then                                     
            return(i)
        end
    end
    return(nil)
end
---@param length number
---@return string
local function idgen(length)
    length = length or 16
    local chars = {
        --* Small chars
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", 
        "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
        --* Capital chars
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", 
        "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
        --* Numbers
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        --* Special chars
        "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_", "=", "+", 
        "{", "}", "[", "]", ":", ";", "'", "<", ">", ",", ".", "?", "/"
    }
    local ret = ""
    for i = 1, length, 1 do
        ret = ret..chars[love.math.random(1, #chars)]
    end
    return(ret)
end
--? lib stuff
local guified = {
    --? vars
    __VER__ = "A-1.0.1",
    registry = {
        elements = {
            button = {
                ---@param argtext string
                ---@param h number
                ---@param w number
                ---@param argx number
                ---@param argy number
                ---@return element
                new = function(self, argx, argy, w, h, argtext)
                    return({
                        name = "button",
                        draw = function(args)
                            if args ~= nil then
                                argx = args.x or argx
                                argy = args.y or argy
                                argtext = args.text or argtext
                            end
                            love.graphics.rectangle("line", argx, argy, w, h)
                            local charWidth = fontsize / 2 --* Approx width of each character in a monospace font of size 12
                            love.graphics.print(argtext, argx + (w / 2) - (#argtext * charWidth / 2), argy + (h / 2) - charWidth)
                        end,
                        pressed = function()
                            local mouseX, mouseY = love.mouse.getPosition()
                            if love.mouse.isDown(1) then
                                if mouseX >= argx and mouseX <= argx + w and mouseY >= argy and mouseY <= argy + h then
                                    return(true)
                                else
                                    return(false)
                                end
                            end
                        end,
                        text = function(text)
                            argtext = text
                        end,
                        changePos = function(x, y, argw, argh)
                            argx = x
                            argy = y
                        end,
                        changeSize = function(argw, argh)
                            w = argw
                            h = argh
                        end
                    })
                end
            },
            textBox = {
                ---@param argx number
                ---@param argy number
                ---@param text string
                ---@return element
                new = function(self, argx, argy, text)
                    return({
                        name = "textBox",
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
                end,
            },
            textInput = { --TODO DELAYED
                new = function(self, argx, argy, w, h, placeholder, active)
                    warnf("TextInput is a praceholder currently")
                    --error("This element in not implimented yet !")
                    if not(active) then
                        active = false
                    end
                    local ret = {
                        text = "",
                        draw = function()
                            love.graphics.print(self.ret.text)
                        end,
                        update = function()
                            
                        end,
                    }
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
                    return({
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
                    return({
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
        ---@param element element
        ---@param id_length number optional
        ---@param noerr boolean optional
        ---@return nil
        register = function(element, id_length, noerr) --? register an element
            if type(id_length):lower() == "boolean" then
                noerr = id_length
                id_length = nil
            end
            if element ~= nil then
                if id_length or 16 < 6 then
                    warnf("ID REG for "..element.name.." is too short")
                end
                local place = #guifiedlocal.internalregistry.drawstack + 1
                local id = idgen(id_length or 16)
                for i = 1, #guifiedlocal.internalregistry.ids, 1 do
                    if id == guifiedlocal.internalregistry.ids[i] then
                        if noerr then
                            return(false)
                        else
                            error("Failed to register element "..element.name.."\nID already exists")
                        end
                    end
                end
                element.id = id
                guifiedlocal.internalregistry.ids[place] = element.id
                guifiedlocal.internalregistry.drawstack[#guifiedlocal.internalregistry.drawstack + 1] = element.draw
                if element.update ~= nil then
                    --guifiedlocal.internalregistry.updatestack[#guifiedlocal.internalregistry.drawstack] = element.update
                    guifiedlocal.internalregistry.updatestack[element.id] = element.update
                    print(#guifiedlocal.internalregistry.drawstack)
                    print("element "..element.name.." update registered ID: "..element.id)
                end
                print("element "..element.name.." draw registered ID: "..element.id)
                if noerr then
                    return(true)
                end
            else
                if not(noerr) then
                    error("No element provided to register")
                else
                    return(false)
                end
            end
        end,
        ---@param element element
        ---@param noerr boolean optional
        ---@return nil
        remove = function(element, noerr) --? removes an element
            if element ~= nil then
                noerr = noerr or false
                if type(element) == "string" then
                    local id = element
                    element = {name = id, id = id}
                    warnf("USING A ID TO REMOVE A ELEMENT IS NOT RECOMENED")
                end
                if element.id ~= nil then
                    local place = getIndex(guifiedlocal.internalregistry.ids, element.id)
                    table.remove(guifiedlocal.internalregistry.drawstack, place)
                    if guifiedlocal.internalregistry.updatestack[place] ~= nil then
                        guifiedlocal.internalregistry.updatestack[element.id] = nil
                    end
                    table.remove(guifiedlocal.internalregistry.ids, place)
                    print("element "..element.name.." removed ID: "..element.id)
                    element.id = nil
                    if noerr then
                        return(true)
                    end
                else
                    if not(noerr) then
                        error("Element "..element.name.." is not registed")
                    else
                        return(false)
                    end
                end
            else
                if not(noerr) then
                    error("No element provided to remove")
                else
                    return(false)
                end
            end
        end
    },
    --? gui funcs
    setWindowToBeOnTop = function() --* sets the Window set to always on top.
        guifiedlocal.setWindowToBeOnTop(love.window.getTitle())
    end,
    toggleDraw = function() --* toggles draw
        guifiedlocal.enabledraw = not(guifiedlocal.enabledraw)
    end,
    toggleUpdate = function() --* toggles update
        guifiedlocal.enableupdate = not(guifiedlocal.enableupdate)
    end,
    ---@return boolean
    getDrawStatus = function() --* returns the draw status
        return(guifiedlocal.enabledraw)
    end,
    ---@return boolean
    getUpdateStatus = function() --* returns the update status
        return(guifiedlocal.enableupdate)
    end,
    ---@return table
    getIdTable = function() --* returns the table contaning ids 
        return(guifiedlocal.internalregistry.ids)
    end,
    ---@return number
    getFontSize = function() --* returns the font size
        return(fontsize)
    end,
    ---@param size number
    setFontSize = function(size) --* sets the font size
        fontsize = size
    end
}
--? override stuff
function love.run()
	if love.load then 
        love.load(love.arg.parseGameArguments(arg), arg)
    end
	--* We don't want the first frame's dt to include time taken by love.load.
	if love.timer then 
        love.timer.step() 
    end
	local dt = 0
	--* Main loop time.
	return function()
		--* Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a, b, c, d, e, f)
			end
		end
		--* Update dt, as we'll be passing it to update
		if love.timer then 
            dt = love.timer.step()
        end
        --? guified code
        if guifiedlocal.update and guifiedlocal.enableupdate then
            guifiedlocal.internalregistry.data = guifiedlocal.update(dt, guifiedlocal.internalregistry.updatestack, guifiedlocal.internalregistry.ids)
        end
        --? guified code end
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
            --? guified code
            if guifiedlocal.draw and guifiedlocal.enabledraw then
                guifiedlocal.draw(guifiedlocal.internalregistry.drawstack, guifiedlocal.internalregistry.data)
            end
            --? guified code end
			love.graphics.present()
		end
		if love.timer then
            love.timer.sleep(0.001)
        end
	end
end
--* post init
guifiedlocal.setWindowToBeOnTop = OSinterop(warnf).setWindowToBeOnTop
--* svc init
guified.registry.register({
    name = "warnSVC Guified internal",
    draw = function()
    end,
    update = function()
        for i = 1, #guifiedlocal.internalregistry.warns, 1 do
            local warnelement = guified.registry.elements.textBox:new(0, love.graphics.getHeight() - ((i * fontsize * 2) - #guifiedlocal.internalregistry.warns), guifiedlocal.internalregistry.warns[i])
            warnelement.name = "warnSVC Guified internal warning"
            guified.registry.register(warnelement)
            guifiedlocal.internalregistry.warns[i] = nil
        end
    end
})
return(guified)
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
