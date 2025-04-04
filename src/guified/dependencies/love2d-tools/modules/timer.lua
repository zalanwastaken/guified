local function getScriptFolder() --* get the path from the root folder in which THIS script is running
	return (debug.getinfo(1, "S").source:sub(2):match("(.*/)"))
end
local class = require(getScriptFolder() .. "class")

---@class Timer
---@field orig number Original duration
---@field seconds number Seconds until timer end
---@field rounded_seconds number Rounded seconds until timer end
---@field elapsed boolean Timer has ended
---@field OnEnd function Function called when timer ends
local M = {}
M.orig = 0
M.seconds = 0
M.rounded_seconds = math.floor(M.seconds)

M.elapsed = false

---Update the timer.
---@param self table
---@param dt integer
---@return integer self.secs Time countdown.
---@return boolean elapsed True if the timer ended.
function M:Update(dt)
	if self.seconds > 0 then
		self.seconds = self.secs - dt
	elseif self.seconds < 0 then
		self.seconds = 0
		self.elapsed = true
		return self.seconds, true
	end
	if self.elapsed then
		self.elapsed = false
		self:Reset()
		self:OnEnd()
	end

	self.rounded_seconds = math.floor(self.seconds)
	return self.seconds, false
end

---Reset the timer to the original duration (or another duration).
---@param self table
---@param new_duration? integer
---@return integer self.secs Time countdown.
function M:Reset(new_duration)
	if not new_duration then
		self.seconds = self.orig
	else
		self.seconds = new_duration
	end
	self.elapsed = false
	return self.seconds
end

M.OnEnd = function(self)
	print(("Timer %s ended!"):format(tostring(self)))
end

local M_class = class(M)

---Create a new timer
---@param duration number
---@return Timer
local function new(duration)
	local timer_obj = M_class:new()
	timer_obj.seconds = duration
	timer_obj.orig = duration
	return timer_obj
end

return new
