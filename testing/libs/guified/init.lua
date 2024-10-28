--? config
local fontsize = 12
local VK_CAPITAL = 0x14 -- Virtual-Key Code for Caps Lock
--?FFI
local ffi = require("ffi")
ffi.cdef[[
    //! C code
    typedef void* HWND;
    HWND FindWindowA(const char* lpClassName, const char* lpWindowName);
    int SetWindowPos(HWND hWnd, HWND hWndInsertAfter, int X, int Y, int cx, int cy, unsigned int uFlags);
    static const unsigned int SWP_NOSIZE = 0x0001;
    static const unsigned int SWP_NOMOVE = 0x0002;
    static const unsigned int SWP_SHOWWINDOW = 0x0040;
    short GetKeyState(int nVirtKey);
]]
--? all script funcs
local function getScriptFolder()
    return(debug.getinfo(1, "S").source:sub(2):match("(.*/)"))
end
local function isCapsLockOn()
    -- GetKeyState returns a value where the lowest bit indicates the key's toggle state.
    local state = ffi.C.GetKeyState(VK_CAPITAL)
    return state ~= 0 and bit.band(state, 0x0001) ~= 0
end
local function getIndex(table, val)
    for i = 1, #table, 1 do
        if table[i] == val then
            return(i)
        end
    end
    return(nil)
end
local function idgen(length)
    local chars = {
        --* Small chars
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", 
        "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
        --* Capital chars
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", 
        "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
        --* Numbers
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
    }
    local ret = ""
    for i = 1, length, 1 do
        ret = ret..chars[love.math.random(1, #chars)]
    end
    return(ret)
end
--? init stuff
local font = love.graphics.newFont(getScriptFolder().."Ubuntu-L.ttf")
love.graphics.setFont(font, fontsize)
love.graphics.setColor(1, 1, 1, 1)
love.math.setRandomSeed(os.time())
--? local stuff
local guifiedlocal = {
    --? vars
    enableupdate = true,
    enabledraw = true,
    internalregistry = {
        drawstack = {},
        updatestack = {},
        data = {},
        ids = {}
    },
    --?funcs
    update = function(dt, updatestack)
        local data = {}
        for i = 1, #updatestack, 1 do
            if updatestack[i] ~= nil then
                data[i] = updatestack[i](dt) --? call the draw func
            end
        end
        return(data)
    end,
    draw = function(drawstack, data)
        for i = 1, #drawstack, 1 do
            drawstack[i](data[i]) --? call the draw func
        end
    end,
    setWindowToBeOnTop = function(title, noerr)
        local HWND_TOPMOST = ffi.cast("HWND", -1)
        local HWND_NOTOPMOST = ffi.cast("HWND", -2)
        local hwnd = ffi.C.FindWindowA(nil, title)
        if hwnd == nil then
            print("HWND not found!")
            if noerr then
                return(false)
            else
                error("HWND not found !")
            end
        else
            print("Found window handle:", hwnd)
            --* Set the window to always be on top
            ffi.C.SetWindowPos(hwnd, HWND_TOPMOST, 0, 0, 0, 0, ffi.C.SWP_NOSIZE + ffi.C.SWP_NOMOVE + ffi.C.SWP_SHOWWINDOW)
            print("Window set to always on top.")
            if noerr then
                return(true)
            end
        end
    end
}
--? lib stuff
local guified = {
    --? vars
    __VER__ = "INF-DEV-1",
    registry = {
        elements = {
            button = {
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
                                end
                            end
                        end,
                        text = function(text)
                            argtext = text
                        end,
                        changePos = function(x, y, argw, argh)
                            argx = x
                            argy = y
                            w = argw or w
                            h = argh or h
                        end
                    })
                end
            },
            textBox = {
                new = function(self, argx, argy, text)
                    return({
                        name = "textBox",
                        draw = function()
                            love.graphics.print(text, argx, argy)
                        end,
                        text = function(argtext)
                            text = argtext
                        end,
                        changePos = function(x, y)
                            argx = x
                            argy = y
                        end
                    })
                end,
            },
            textInput = { --TODO
                new = function(self, argx, argy, w, h, placeholder, active)
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
            }
        },
        register = function(element) --? register an element
            if element ~= nil then
                --element.ourplace = #guifiedlocal.internalregistry.drawstack + 1
                local place = #guifiedlocal.internalregistry.drawstack + 1
                element.id = idgen(16)
                guifiedlocal.internalregistry.ids[place] = element.id
                guifiedlocal.internalregistry.drawstack[#guifiedlocal.internalregistry.drawstack + 1] = element.draw
                if element.update ~= nil then
                    guifiedlocal.internalregistry.updatestack[#guifiedlocal.internalregistry.drawstack] = element.update
                else
                    print("No update function found for element "..element.name)
                end
                print("registered element as "..element.id.." at place "..place)
            else
                error("No element provided to register")
            end
        end,
        remove = function(element) --? remove and element
            if element ~= nil then
                if element.id ~= nil then
                    local place = getIndex(guifiedlocal.internalregistry.ids, element.id)
                    table.remove(guifiedlocal.internalregistry.drawstack, place)
                    if guifiedlocal.internalregistry.updatestack[place] ~= nil then
                        table.remove(guifiedlocal.internalregistry.updatestack, place)
                    end
                    table.remove(guifiedlocal.internalregistry.ids, element.ourplace)
                    --element.ourplace = nil
                else
                    print("element is not registered !")
                end
            else
                error("No element provided to remove")
            end
        end
    },
    --? funcs
    setWindowToBeOnTop = function()
        guifiedlocal.setWindowToBeOnTop(love.window.getTitle())
    end,
    toggleDraw = function()
        guifiedlocal.enabledraw = not(guifiedlocal.enabledraw)
    end,
    toggleUpdate = function()
        guifiedlocal.enableupdate = not(guifiedlocal.enableupdate)
    end,
    getDrawStatus = function()
        return(guifiedlocal.enabledraw)
    end,
    getUpdateStatus = function()
        return(guifiedlocal.enableupdate)
    end,
    getIdTable = function()
        return(guifiedlocal.internalregistry.ids)
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
            guifiedlocal.internalregistry.data = guifiedlocal.update(dt, guifiedlocal.internalregistry.updatestack)
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
return(guified)
