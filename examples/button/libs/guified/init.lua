--? local stuff
local guifiedlocal = {
    --? vars
    enableupdate = true,
    enabledraw = true,
    internalregistry = {
        drawstack = {},
        updatestack = {},
        data = {}
    },
    --?funcs
    update = function(dt, updatestack)
        local data = {}
        for i = 1, #updatestack, 1 do
            if updatestack[i] ~= nil then
                data[i] = updatestack[i](dt, i) --? call the draw func
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
        local ffi = require("ffi")
        ffi.cdef[[
            //! C code
            typedef void* HWND;
            HWND FindWindowA(const char* lpClassName, const char* lpWindowName);
            int SetWindowPos(HWND hWnd, HWND hWndInsertAfter, int X, int Y, int cx, int cy, unsigned int uFlags);
            static const unsigned int SWP_NOSIZE = 0x0001;
            static const unsigned int SWP_NOMOVE = 0x0002;
            static const unsigned int SWP_SHOWWINDOW = 0x0040;
        ]]
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
    __VER__ = "INF-DEV",
    registry = {
        elements = {
            button = {
                new = function(argx, argy, w, h, argtext)
                    return({
                        name = "button",
                        draw = function(args)
                            if args ~= nil then
                                argx = args.x or argx
                                argy = args.y or argy
                                argtext = args.text or argtext
                            end
                            love.graphics.rectangle("line", argx, argy, w, h)
                            love.graphics.print(argtext, argx, argy)
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
                        changePos = function(x, y)
                            argx = x
                            argy = y
                        end
                    })
                end
            },
            textBox = {
                new = function(argx, argy, text)
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
            }
        },
        register = function(element)
            if element ~= nil then
                element.ourplace = #guifiedlocal.internalregistry.drawstack + 1
                guifiedlocal.internalregistry.drawstack[#guifiedlocal.internalregistry.drawstack + 1] = element.draw
                if element.update ~= nil then
                    guifiedlocal.internalregistry.updatestack[#guifiedlocal.internalregistry.drawstack] = element.update
                else
                    print("No update function found for element "..element.name)
                end
            else
                error("No element provided to register")
            end
        end,
        remove = function(element)
            if element ~= nil then
                if element.ourplace ~= nil then
                    table.remove(guifiedlocal.internalregistry.drawstack, element.ourplace)
                    element.ourplace = nil
                else
                    print("element is not registered !")
                end
            else
                error("No element provided to rmeove")
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
    end
}
--? override stuff
function love.run()
	if love.load then 
        love.load(love.arg.parseGameArguments(arg), arg) 
    end
	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then 
        love.timer.step() 
    end
	local dt = 0
	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end
		-- Update dt, as we'll be passing it to update
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
