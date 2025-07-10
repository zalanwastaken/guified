---@class InputHandler
---@field mapped KeyBind[] Mapped keys
local M = {}
M.mapped = {}

-- ##############
-- ## KEYBOARD ##
-- ##############

---Add/set a keybind
---@param key string Key
---@param func function Function
---@param ...? table Function arguments
function M.Map(key, func, ...)
	local arg = { ... }

	---@class KeyBind
	---@field action function Called when key is pressed
	---@field args table Arguments to "action"
	local keybind = {
		action = func,
		args = {},
	}
	if #arg > 0 then
		for k, v in pairs(arg) do
			keybind.args[k] = v
		end
	end

	M.mapped[key] = keybind
	return keybind
end

---Update all keybinds.
---@param current string Current key
function M:UpdateKeys(current)
	for key, keybind in pairs(self.mapped) do
		if current == key then
			if #keybind.args > 0 then
				keybind.action(keybind.args)
			else
				keybind.action()
			end
		end
	end
end

-- ###########
-- ## MOUSE ##
-- ###########

---Mouse is hovering a certain area
---@param x1 number Left side
---@param y1 number Top
---@param x2 number Right side
---@param y2 number Bottom
---@return boolean Hovering
function M.IsHovering(x1, y1, x2, y2)
	local cx, cy = love.mouse.getPosition()
	return (cx > x1 and cx < x2 and cy > y1 and cy < y2)
end

---Returns if mouse is being holded and the mouse button holded.
---@return boolean Holded False if not being holded
---@return integer Button 0 if not being holded
function M.IsHoldingMouse()
	local isDown = love.mouse.isDown
	if isDown(1) then
		return true, 1
	elseif isDown(2) then
		return true, 2
	elseif isDown(3) then
		return true, 3
	else
		return false, 0
	end
end

---@alias MouseButton
---| 1 # Left mouse button
---| 2 # Right mouse button
---| 3 # Middle mouse button

---Returns if a mouse button is being holded
---@param button MouseButton
---@return boolean Holded
function M.MouseButtonHolded(button)
	if button > 3 then
		return false
	elseif button < 1 then
		return false
	end
	return love.mouse.isDown(button)
end

---@class RectArea
---@field x1 number Left side
---@field y1 number Top
---@field x2 number Right side
---@field y2 number Bottom

---Call a function if an area is being hovered.
---@param area RectArea Area
---@param func function Action
---@param ...? table Arguments
---@return boolean Hovering
---@return nil|any Returned Values returned by the function, nil if not hovered
function M.IfHovering(area, func, ...)
	local arg = { ... }
	if M.IsHovering(area.x1, area.y1, area.x2, area.y2) then
		if #arg > 0 then
			return true, func(arg)
		else
			return true, func()
		end
	else
		return false
	end
end

return M
