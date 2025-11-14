--* Error handling

local utf8 = require("utf8")

local tbl = require(__GUIFIEDGLOBAL__.rootfolder..".dependencies.logger.init")

---@type logger
local logger = tbl.logger
---@type guifiedloggerinterface
local guifiedloggerinterface = tbl.guifiedloggerinterface

local function error_printer(msg, layer)
	logger.fatal(msg)
	logger.trace(debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", ""))
	logger.regular("Found a bug ?\nPlease report it to the Guified repo as a issue !\nThanks !")
	guifiedloggerinterface.stopSVC()
end

local fun_messages = {
	"oops !",
	"did i do this?",
	"meow",
	"hi im guified i LOVE to crash",
	"Crashaholic edition",
	"Ayooo",
	"hmmm",
	"*villager noises*",
	"huh?",
	"not my fault!",
	"runtime error? more like runSOMETIMES error",
	"function not found, just like my motivation",
	"your code called, it wants a lawyer",
	"ok but why did YOU trust me with your UI?",
	"hello darkness my old friend"
}
fun_messages = fun_messages[love.math.random(1, #fun_messages)]

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
		love.graphics.printf((__GUIFIEDGLOBAL__.__VER__ or "Unknown version").."\n"..fun_messages, 0, 88, love.graphics.getWidth(), "center")
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
	local name = love.window.getTitle()
	--[[
    if #name == 0 or name == "Untitled" then 
        love.window.setTitle("Guified error")
    end
	--]]
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

function love.threaderror(thread, errorstr)
	if not(logger.thread:isRunning()) then
		print("Thread error!\n"..errorstr)
	else
		logger.error("Thread error!\n"..errorstr)
	end
end

return true
