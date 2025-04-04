local function getScriptFolder() --* get the path from the root folder in which THIS script is running
	return (debug.getinfo(1, "S").source:sub(2):match("(.*/)"))
end

---@type logger
local logger = require(getScriptFolder() .. "logger.init")

---@class DebugHelper
local M = {}

---@private
---Generate an assert message
---@param msg? string Plain message
---@param extra? string Extra notes
---@return string Generated Generated message
local function GenerateAssertMsg(msg, extra)
	if msg and extra then
		return ("Assertion failed: %s (%s)"):format(extra, msg)
	elseif msg and not extra then
		return ("Assertion failed: %s"):format(msg)
	end

	local time = tostring(os.date("%H:%M:%S"))
	return ("Assertion failed [%s]"):format(time)
end

---Check if a value is not `false` or `nil`, in that case make an error jump.
---@param value any
---@param msg? any Message to be displayed. Default = Assertion failed [(Hour):(Minute):(Second)]
---@return any|nil Value
function M.Assert(value, msg)
	if value then
		return value
	end
	error(GenerateAssertMsg(msg))
end

---Check if a value is not `false` or `nil`, in that case log an **ERROR** message and return `nil`.
---
---If `value` is not `false` or `nil`, returns `value`.
---@param value any
---@param msg? string Message to be logged. Default = Assertion failed [(Hour):(Minute):(Second)]
---@return any|nil Value
function M.LogAssert(value, msg)
	if value then
		return value
	end

	logger.error(GenerateAssertMsg(msg))
	return nil
end

---Check if two values are **equal**. **If they are** returns the **first value** (`a`).
---@param a any First value
---@param b any Second value
---@param msg? string Message to display. Default = (`a`) and (`b`) are not equal
---@return any|nil A First value
function M.Equal(a, b, msg)
	if a == b then
		return a
	end
	error(GenerateAssertMsg(msg, ("%s and %s are not equal"):format(tostring(a), tostring(b))))
end

---Check if two values are **not equal**. **If they are not** returns the **first value** (`a`).
---@param a any First value
---@param b any Second value
---@param msg? string Message to display. Default = (`a`) and (`b`) are equal
---@return any|nil A First value
function M.NotEqual(a, b, msg)
	if a ~= b then
		return a
	end
	error(GenerateAssertMsg(msg, ("%s and %s are equal"):format(tostring(a), tostring(b))))
end

---Checks if a value is of a certain *type*.
---@param value any Value
---@param type type Type
---@param msg? string Message to display. Default = (Value) is not a (Type)
---@return any|nil Value
function M.IsType(value, type, msg)
	type = tostring(type)
	if type(value) == type then
		return value
	end
	error(GenerateAssertMsg(msg, ("%s is not a %s"):format(tostring(value), type)))
end

---Checks if a value is one of the values inside `tabl`.
---@param tabl table Values
---@param value any Value to check
---@param msg? string Message to display. Default = (Value) is not one of (Values)
---@return any|nil Value
function M.IsOneOf(tabl, value, msg)
	for _, v in ipairs(tabl) do
		if value == v then
			return value
		end
	end

	local values = {}
	for i in ipairs(tabl) do
		values[i] = tostring(tabl[i])
	end
	local values_string = table.concat(values, ", ")
	error(GenerateAssertMsg(msg, ("%s is not one of %s"):format(tostring(value), values_string)))
end

---Checks if a value is of a certain *type* **or** `nil`.
---
---Useful for optional parameters.
---@param value any Value
---@param type type Type
---@param msg? string Message. Default = (Value) is not a (Type) or `nil`
---@return any|nil Value
function M.IsOptionalType(value, type, msg)
	if value == nil then
		return value
	end

	type = tostring(type)
	if type(value) == type then
		return value
	end
	error(GenerateAssertMsg(msg, ("%s is not a %s or nil"):format(tostring(value), type)))
end

return M
