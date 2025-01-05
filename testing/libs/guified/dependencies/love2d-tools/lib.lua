--[[ 
!!! IMPORTANT !!!
THIS FILE DOES NOT NEED TO BE MODIFIED FOR ANYTHING THAT ISN'T ADDING/REMOVING A MODULE FROM THE LIBRARY.
IF YOU WANT TO MODIFY A MODULE, MODIFY THE FILE IN "modules/<module_name>.lua".

If you want to add a module:
- Add it to "Tools" if it is a regular module
- Make a function in "Tools" if it is a class
All module names have to be lowercase and "snake_case" has to be used.
-- ]]
local function getScriptFolder() --* get the path from the root folder in which THIS script is running
	return (debug.getinfo(1, "S").source:sub(2):match("(.*/)"))
end
local path = getScriptFolder() .. "src."
local Tools = {
	-- NOTE: edited to use the path variable
	---@type Math
	math = require(path .. "modules.math"),
	---@type TableExtension
	table = require(path .. "modules.table"),
	---@type Database
	database = require(path .. "modules.database"),
	---@type messageBus
	message_bus = require(path .. "modules.messagebus"),
	---@type logger
	logger = require(path .. "modules.logger"),
	---@type InputHandler
	input = require(path .. "modules.input"),
	---@type DebugHelper
	debug = require(path .. "modules.debug"),
	lib_info = {
		author = "Nykenik24",
		url = "https://github.com/Nykenik24/love2d-tools",
		license = [[
MIT License

Copyright (c) 2024 Nykenik

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
	]],
	},
}

---Create a new class
---@param attributes table
---@return Class
Tools.class = function(attributes)
	return require(path .. "modules.class")(attributes)
end

---Create a new timer
---@param duration number
---@return Timer
Tools.timer = function(duration)
	return require(path .. "modules.timer")(duration)
end

---Create a new state machine
---@return StateMachine
Tools.state = function()
	return require(path .. "modules.state")()
end

---Create a new vector
---@param x number
---@param y number
---@return Vector2
Tools.vec2 = function(x, y)
	return require(path .. "modules.vec2")(x, y)
end

Tools._mt = { _index = Tools }

return Tools
