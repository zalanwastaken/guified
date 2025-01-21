--- Utility to get the folder of the script being executed.
--- This fetches the path from the root directory in which the script is located.
---@return string path The directory path where the script is running.
local function getScriptFolder()
	return (debug.getinfo(1, "S").source:sub(2):match("(.*/)"))
end

-- Internal logger state and thread management
---@class loggerinternal
local loggerinternal = {}
loggerinternal.write = love.thread.newThread(getScriptFolder() .. "loggerthread.lua") -- Thread to handle logging operations.
loggerinternal.datastack = love.thread.getChannel("loggerdata") -- Data channel for sending logs to the thread.

-- Logger module
---@class logger
---@field regular function Regular message
---@field trace function Trace message
---@field debug function Debug message
---@field info function Information message
---@field ok function Indicates something works/worked
---@field warn function Warning
---@field error function Error
---@field fatal function Fatal error
---@field _chained table Methods for chained messages
local M = {}

---@alias log_types
---| `"regular"`
---| `"trace"`
---| `"debug"`
---| `"info"`
---| `"ok"`
---| `"warn"`
---| `"error"`
---| `"fatal"`
local log_types = {
	regular = "\27[37m",
	trace = "\27[34m",
	debug = "\27[36m",
	info = "\27[32m",
	ok = "\27[32m",
	warn = "\27[33m",
	error = "\27[31m",
	fatal = "\27[35m",
}

M._chained = {}
M.chain_number = 1
local clear_color = "\27[0;0m"
for k, v in pairs(log_types) do
	---@param content string Log content
	---@return table Chained
	M[k] = function(content)
		loggerinternal.datastack:push(
			("%s[%s %s]:%s %s"):format(v, tostring(os.date("%H:%M:%S")), k:upper(), clear_color, content)
		)
		M.chain_number = 1
		return M._chained
	end
	---@param content string Log content
	---@return table Chained
	M._chained[k] = function(content)
		loggerinternal.datastack:push(
			("%s[%s CHAINED %i %s]:%s %s"):format(
				v,
				tostring(os.date("%H:%M:%S")),
				M.chain_number,
				k:upper(),
				clear_color,
				content
			)
		)

		M.chain_number = M.chain_number + 1
		return M._chained
	end
end

---If `boolean` is **true** then `messages.yes` is logged with type `types.yes`
---If `boolean` is **false** then `messages.no` is logged with type `types.no`
---@param boolean boolean
---@param types table<string, log_types>
---@param messages table<string, string>
---@return table Chained
function M.Choose(boolean, types, messages)
	types.yes = types.yes or "ok"
	types.no = types.no or "error"
	if not messages.yes or not messages.no then
		if boolean then
			M[types.yes]("Condition is true")
		else
			M[types.no]("Condition is false")
		end
		return M._chained
	end

	if boolean then
		M[types.yes](messages.yes)
	else
		M[types.no](messages.no)
	end
	return M._chained
end

---Print a table in a readable format.
---
---Uses ANSI Colors
---@param t table Table printed
---@param depth? integer Used to make the function recursive
function M.PrintTable(t, depth)
	local print = function(msg)
		loggerinternal.datastack:push(msg)
	end

	local function Tabs(n)
		local tabs = ""
		for _ = 1, n do
			tabs = tabs .. "\t"
		end
		return tabs
	end

	depth = depth or 1
	local tabs = Tabs(depth)
	local start = tabs .. "%s = {"
	local formatted_start = start:format(tostring(t))
	print("\27[1;34m " .. formatted_start:sub(#"table: " + 2, #formatted_start))
	for k, v in pairs(t) do
		if type(k) == "number" and type(v) ~= "table" then
			print("\27[0;32m " .. (tabs .. "[%i] \27[0;0m= "):format(k) .. "\27[0;0m" .. tostring(v))
		elseif type(k) == "string" and type(v) ~= "table" then
			print("\27[0;35m " .. (tabs .. "[%s] \27[0;0m= "):format(k) .. "\27[0;0m" .. tostring(v))
		end

		if type(v) == "table" then
			M.PrintTable(v, depth + 1)
		end
	end
	if depth > 1 then
		print(Tabs(depth - 1) .. "}")
	else
		print("\27[1;34m } \27[0;0m")
	end
end

--- Starts the logging service by starting the thread.
function M.startSVC()
	loggerinternal.write:start()
end

--- Stops the logging service by signaling the thread to stop and waiting for it to finish.
function M.stopSVC()
	loggerinternal.datastack:push("STOP") -- Signal to stop the logger thread.
	loggerinternal.write:wait() -- Wait for the thread to finish execution.
end

return M
