local function getScriptFolder() --* get the path from the root folder in which THIS script is running
	return (debug.getinfo(1, "S").source:sub(2):match("(.*/)"))
end
local class = require(getScriptFolder() .. "class")

---@class Vector2
---@field x number x coordinate
---@field y number y coordinate
---@field angle number vector angle
local M = {}
M.x = 0
M.y = 0
M.angle = 0
M.magnitude = 0

---Compare "x" and "y" of two vectors
---@param self Vector2
---@param b Vector2 Second vector
---@return Vector2 Winner
function M.Compare(self, b)
	if self.x > b.x and self.y > b.y then
		return self
	elseif self.x < b.x and self.y < b.y then
		return b
	else
		return self
	end
end

---Compare "x" of two vectors
---@param self Vector2
---@param b Vector2 Second vector
---@return Vector2 Winner
function M.CompareX(self, b)
	if self.x > b.x then
		return self
	else
		return b
	end
end

---Compare "y" of two vectors
---@param self Vector2
---@param b Vector2 Second vector
---@return Vector2
function M.CompareY(self, b)
	if self.y > b.y then
		return self
	else
		return b
	end
end

---Rotate the vector.
---
---To overwrite the angle use SetAngle()
---@param self Vector2
---@param angle number Target rotation
---@return number
function M.Rotate(self, angle)
	local max_angle = math.pi * 2

	local final_angle = self.angle + angle
	if final_angle > max_angle then
		final_angle = 0 + (math.max(max_angle, angle) - math.min(max_angle, angle))
	elseif final_angle < 0 then
		final_angle = max_angle - (math.max(max_angle, angle) - math.min(max_angle, angle))
	end

	self.angle = final_angle
	return final_angle
end

---Adds to the position of the vector.
---@param self Vector2
---@param x number Number added to the x position.
---@param y number Number added to the y position.
---@return Vector2
function M.Move(self, x, y)
	local moved_vector = self
	moved_vector.x = self.x + x
	moved_vector.y = self.y + y

	self = moved_vector
	return moved_vector
end

---Overwrites the position of the vector.
---@param self Vector2
---@param x number Target x position
---@param y number Target y position
---@return Vector2
function M.Translate(self, x, y)
	self.x = x
	self.y = y

	return self
end

---Draw the vector.
---
---Requires being called in Love2d to work.
---@param self Vector2
---@param orig_x? number X original point. Default = center of screen
---@param orig_y? number Y original point. Default = center of screen
function M.Draw(self, orig_x, orig_y)
	orig_x, orig_y = love.graphics:getWidth() / 2, love.graphics:getHeight() / 2
	love.graphics.line(orig_x, orig_y, self.x, self.y)
end

local M_class = class(M)

--Create a new vector
---@param x number
---@param y number
---@return Vector2
local function new(x, y)
	local obj = M_class:new()
	obj.x = x
	obj.y = y
	return obj
end

return new
