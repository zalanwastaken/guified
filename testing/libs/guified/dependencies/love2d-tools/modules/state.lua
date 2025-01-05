local function getScriptFolder() --* get the path from the root folder in which THIS script is running
	return (debug.getinfo(1, "S").source:sub(2):match("(.*/)"))
end
local class = require(getScriptFolder() .. "class")

---@class StateMachine
---@field states table Defined states
---@field current string Current state's name
local M = {}

---Create a new state
---@param self StateMachine
---@param name string State's name
---@param enabled boolean State's default state (boolean)
---@param info table Info that you want to store in the state
---@return State State Created state
function M.NewState(self, name, enabled, info)
	---@class State
	---@field enabled boolean State's state (boolean)
	local state = {}
	for k, v in pairs(info) do
		state[k] = v
	end
	state.enabled = enabled
	self.states[name] = state
	state.update = function(self, dt)
		print(("State %s update function called"):format(name))
		print('Modify this function or make it "nil"')
	end
	return state
end

---Sets current state
---@param self StateMachine
---@param name string
---@return boolean Succes False if state doesn't exist
function M.SetState(self, name)
	if self.states[name] then
		self.current = name
		return true
	else
		return false
	end
end

---Get current state
---@param self StateMachine
---@return State State Current state
---@return string Name Current state's name
function M.GetState(self)
	if self.states[self.current] then
		return self.states[self.current], self.current
	else
		error("Current state doesn't exist")
	end
end

---Checks if a state exists inside the state machine.
---@param self StateMachine
---@param name string State's name
---@return boolean Exists True if state exists
function M.Exists(self, name)
	if self.states[name] then
		return true
	else
		return false
	end
end

---Call current state's update method.
---@param self StateMachine
---@param dt? number
function M.Update(self, dt)
	local state = self:GetState()
	if state.update then
		local no_errors, error_msg
		if dt then
			no_errors, error_msg = pcall(state.update, state, dt)
		else
			no_errors, error_msg = pcall(state.update, state)
		end
		if no_errors then
			if dt then
				state.update(state, dt)
			else
				state.update(state)
			end
		else
			error(error_msg)
		end
	end
end

local M_class = class(M)

---Create a new state machine
---@return StateMachine
local function new()
	return M_class:new()
end

return new
