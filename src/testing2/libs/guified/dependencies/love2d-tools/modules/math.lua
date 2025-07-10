---@class Math
---@field pi number Pi (3.1415926535898)
local M = {}
M.pi = math.pi

-- #############
-- ## GENERAL ##
-- #############

---Linear interpolation between two values (start and ending)
---@param start number Starting value
---@param ending number Ending value
---@param factor number Interpolation factor. Range: 0-1
---@return number Interpolated Interpolated value
function M.Lerp(start, ending, factor)
	factor = M.Clamp(factor, 0, 1)
	return start + (ending - start) * factor
end

---Restricts a value to the specified range (minimum to maximum)
---@param value number
---@param minimum number
---@param maximum number
---@return number Clamped Clamped value
function M.Clamp(value, minimum, maximum)
	return math.min(minimum, math.min(maximum, value))
end

---Wraps a value to the specified range (minimum to maximum)
---@param value number
---@param minimum number
---@param maximum number
---@return number Wrapped Wrapped value
function M.Wrap(value, minimum, maximum)
	return minimum + ((value - minimum) % (maximum - minimum))
end

-- ########################
-- ## VECTORS & GEOMETRY ##
-- ########################

---Calculate the distance between two vectors
---@param Vector1 Vector2
---@param Vector2 Vector2
---@return number Distance
function M.DistanceBetweenVectors(Vector1, Vector2)
	local x1, y1 = Vector1.x, Vector1.y
	local x2, y2 = Vector2.x, Vector2.y
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

---Calculates the distance between two points
---@param x1 number "x" position of point 1
---@param y1 number "y" position of point 1
---@param x2 number "x" position of point 2
---@param y2 number "y" position of point 2
---@return number Distance
function M.DistanceBetweenPoints(x1, y1, x2, y2)
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

---Calculates the dot product of two vectors
---@param Vector1 Vector2
---@param Vector2 Vector2
---@return number Product Dot product
function M.VectorDotProduct(Vector1, Vector2)
	local x1, y1 = Vector1.x, Vector1.y
	local x2, y2 = Vector2.x, Vector2.y
	return x1 * x2 + y1 * y2
end

---Calculates the dot product of two points
---@param x1 number "x" position of point 1
---@param y1 number "y" position of point 1
---@param x2 number "x" position of point 2
---@param y2 number "y" position of point 2
---@return number Product Dot product
function M.PointDotProduct(x1, y1, x2, y2)
	return x1 * x2 + y1 * y2
end

---Calculates the cross product of two vectors
---@param Vector1 Vector2
---@param Vector2 Vector2
---@return number Product Cross product
function M.VectorCrossProduct(Vector1, Vector2)
	local x1, y1 = Vector1.x, Vector1.y
	local x2, y2 = Vector2.x, Vector2.y
	return x1 * y2 - y1 * x2
end

---Calculates the cross product of two points
---@param x1 number "x" position of point 1
---@param y1 number "y" position of point 1
---@param x2 number "x" position of point 2
---@param y2 number "y" position of point 2
---@return number Product Cross product
function M.PointCrossProduct(x1, y1, x2, y2)
	return x1 * y2 - y1 * x2
end

---Calculates the angle between two vectors
---@param Vector1 Vector2
---@param Vector2 Vector2
---@return number Angle Angle in radians
function M.AngleBetweenVectors(Vector1, Vector2)
	local x1, y1 = Vector1.x, Vector1.y
	local x2, y2 = Vector2.x, Vector2.y
	return math.atan2(y2 - y1, x2 - x1)
end

---Calculates the angle between two points
---@param x1 number "x" position of point 1
---@param y1 number "y" position of point 1
---@param x2 number "x" position of point 2
---@param y2 number "y" position of point 2
---@return number Angle Angle in radians
function M.AngleBetweenPoints(x1, y1, x2, y2)
	return math.atan2(y2 - y1, x2 - x1)
end

---Get the magnitude of a vector
---@param Vector Vector2
---@return number Magnitude Magnitude of the vector
function M.VectorMagnitude(Vector)
	return math.sqrt(Vector.x ^ 2 + Vector.y ^ 2)
end

---Normalize a vector
---@param Vector Vector2
---@return number, number Normalized The normalized "x" and "y" coordinates
function M.NormalizeVector(Vector)
	local magnitude = M.VectorMagnitude(Vector)

	if magnitude == 0 then
		return 0, 0
	end

	return Vector.x / magnitude, Vector.y / magnitude
end

return M
