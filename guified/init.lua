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
--? init stuff
local font = love.graphics.newFont(getScriptFolder().."Ubuntu-L.ttf")
love.graphics.setFont(font, fontsize)
love.graphics.setColor(1, 1, 1, 1)
love.math.setRandomSeed(os.time())
if love.system.getOS():lower() == "linux" then
    love.window.showMessageBox("Warning", "Featurs that use FFI will not work on Linux !", "warning")
end
if love.system.getOS():lower() == "macos" then
    love.window.showMessageBox("Warning", "MacOS is not suppoorted !", "warning")
end
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
            love.graphics.setColor(1, 1, 1, 1)
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
            },
            box = {
                new = function(self, x, y, w, h, mode, clr)
                    if clr == nil then
                        clr = {1, 1, 1, 1}
                    end
                    return({
                        name = "box",
                        draw = function()
                            love.graphics.setColor(clr)
                            love.graphics.rectangle(mode, x, y, w, h)
                        end,
                        changeSize = function(argw, argh)
                            h = argh
                            w = argw
                        end,
                        changePos = function(argx, argy)
                            x = argx
                            y = argy
                        end
                    })
                end
            },
            image = {
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
        register = function(element) --? register an element
            if element ~= nil then
                local place = #guifiedlocal.internalregistry.drawstack + 1
                element.id = idgen(16)
                guifiedlocal.internalregistry.ids[place] = element.id
                guifiedlocal.internalregistry.drawstack[#guifiedlocal.internalregistry.drawstack + 1] = element.draw
                if element.update ~= nil then
                    guifiedlocal.internalregistry.updatestack[#guifiedlocal.internalregistry.drawstack] = element.update
                end
                print("element "..element.name.." registered ID: "..element.id)
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
                    table.remove(guifiedlocal.internalregistry.ids, place)
                    print("element "..element.name.." removed ID: "..element.id)
                    element.id = nil
                else
                    print("element is not registered !")
                end
            else
                error("No element provided to remove")
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
    getDrawStatus = function() --* returns the draw status
        return(guifiedlocal.enabledraw)
    end,
    getUpdateStatus = function() --* returns the update status
        return(guifiedlocal.enableupdate)
    end,
    getIdTable = function() --* returns the table contaning ids 
        return(guifiedlocal.internalregistry.ids)
    end,
    filesystem = {
        --TODO
        read = function(file)
            local fileobj = io.open(file, "r")
            if not fileobj then
                error("Could not open file for reading: " .. file)
            end
            local data = fileobj:read("*a")
            fileobj:close()
            return data
        end,
        write = function(file, data)
            local fileobj = io.open(file, "w")
            if not fileobj then
                error("Could not open file for writing: " .. file)
            end
            fileobj:write(data)
            fileobj:close()
        end,
        readBytes = function(file)
            local fileobj = io.open(file, "rb")
            if not fileobj then
                error("Could not open file for reading bytes: " .. file)
            end
            local data = fileobj:read("*a")
            fileobj:close()
            return data
        end,
        append = function(file, data)
            local fileobj = io.open(file, "a")
            if not fileobj then
                error("Could not open file for appending: " .. file)
            end
            fileobj:write(data)
            fileobj:close()
        end
    }
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
--* Error handling
local utf8 = require("utf8")
local function error_printer(msg, layer)
	print((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
end
function love.errorhandler(msg)
	msg = tostring(msg)
	error_printer(msg, 2)
	if not love.window or not love.graphics or not love.event then
		return
	end
	if not love.graphics.isCreated() or not love.window.isOpen() then
		local success, status = pcall(love.window.setMode, 800, 600)
		if not success or not status then
			return
		end
	end
	-- Reset state.
	if love.mouse then
		love.mouse.setVisible(true)
		love.mouse.setGrabbed(false)
		love.mouse.setRelativeMode(false)
		if love.mouse.isCursorSupported() then
			love.mouse.setCursor()
		end
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs(love.joystick.getJoysticks()) do
			v:setVibration()
		end
	end
	if love.audio then love.audio.stop() end
	love.graphics.reset()
	local font = love.graphics.setNewFont(14)
    local largefont = love.graphics.newFont(44)
	love.graphics.setColor(1, 1, 1)
	local trace = debug.traceback()
	love.graphics.origin()
	local sanitizedmsg = {}
	for char in msg:gmatch(utf8.charpattern) do
		table.insert(sanitizedmsg, char)
	end
	sanitizedmsg = table.concat(sanitizedmsg)
	local err = {}
	table.insert(err, "Error\n")
	table.insert(err, sanitizedmsg)
	if #sanitizedmsg ~= #msg then
		table.insert(err, "Invalid UTF-8 string in error message.")
	end
	table.insert(err, "\n")
	for l in trace:gmatch("(.-)\n") do
		if not l:match("boot.lua") then
			l = l:gsub("stack traceback:", "Traceback\n")
			table.insert(err, l)
		end
	end
	local p = table.concat(err, "\n")
	p = p:gsub("\t", "")
	p = p:gsub("%[string \"(.-)\"%]", "%1")
	local function draw()
		if not love.graphics.isActive() then return end
		love.graphics.clear(0/255, 183/255, 235/255)
        love.graphics.setFont(largefont)
        love.graphics.printf("GUIFIED", 0, 44, love.graphics.getWidth(), "center")
        love.graphics.setFont(font)
		love.graphics.printf(p, 0, love.graphics.getHeight() / 4, love.graphics.getWidth(), "center")
		love.graphics.present()
	end
	local fullErrorText = p
	local function copyToClipboard()
		if not love.system then return end
		love.system.setClipboardText(fullErrorText)
		p = p .. "\nCopied to clipboard!"
	end
	if love.system then
		p = p .. "\n\nPress Ctrl+C or tap to copy this error"
	end
	return function()
		love.event.pump()
		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return 1
			elseif e == "keypressed" and a == "escape" then
				return 1
			elseif e == "keypressed" and a == "c" and love.keyboard.isDown("lctrl", "rctrl") then
				copyToClipboard()
			elseif e == "touchpressed" then
				local name = love.window.getTitle()
				if #name == 0 or name == "Untitled" then name = "Game" end
				local buttons = {"OK", "Cancel"}
				if love.system then
					buttons[3] = "Copy to clipboard"
				end
				local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
				if pressed == 1 then
					return 1
				elseif pressed == 3 then
					copyToClipboard()
				end
			end
		end
		draw()
		if love.timer then
			love.timer.sleep(0.1)
		end
	end
end
return(guified)
