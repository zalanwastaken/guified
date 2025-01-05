local function getScriptFolder() --* get the path from the root folder in which THIS script is running
	return (debug.getinfo(1, "S").source:sub(2):match("(.*/)"))
end
---@type Math
local mathx = require(getScriptFolder() .. "math")

---@class EasingHelper
local M = {}

---Linear interpolation between two values
---@param start number Starting value
---@param ending number Ending value
---@param factor number Interpolation factor. Range: 0-1
---@return number Interpolated Interpolated value
function M.LinearInterpolation(start, ending, factor)
	return mathx.Lerp(start, ending, factor)
end

---Smooth interpolation between two values using a cubic curve
---@param edge_1 number Lower edge
---@param edge_2 number Upper edge
---@param val number Target value
---@return number Interpolated Smoothed value
function M.SmoothInterpolation(edge_1, edge_2, val)
	local clamp = mathx.Clamp
	val = clamp((val - edge_1) / (edge_2 - edge_1), 0.0, 0.1)
	return (val ^ 2) * (3 - 2 * val)
end

--functions from https://github.com/EmmanuelOga/easing/blob/master/lib/easing.lua.
--easing equations from http://robertpenner.com/easing/.
--both licenses are in the "licenses" directory.
---@diagnostic disable: unused-local

local pow = math.pow
local sin = math.sin
local cos = math.cos
local pi = math.pi
local sqrt = math.sqrt
local abs = math.abs
local asin = math.asin

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.Linear(t, b, c, d)
	return c * t / d + b
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.InQuad(t, b, c, d)
	t = t / d
	return c * pow(t, 2) + b
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.OutQuad(t, b, c, d)
	t = t / d
	return -c * t * (t - 2) + b
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.InOutQuad(t, b, c, d)
	t = t / d * 2
	if t < 1 then
		return c / 2 * pow(t, 2) + b
	else
		return -c / 2 * ((t - 1) * (t - 3) - 1) + b
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.OutInQuad(t, b, c, d)
	if t < d / 2 then
		return M.OutQuad(t * 2, b, c / 2, d)
	else
		return M.InQuad((t * 2) - d, b + c / 2, c / 2, d)
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.InCubic(t, b, c, d)
	t = t / d
	return c * pow(t, 3) + b
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.OutCubic(t, b, c, d)
	t = t / d - 1
	return c * (pow(t, 3) + 1) + b
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.InOutCubic(t, b, c, d)
	t = t / d * 2
	if t < 1 then
		return c / 2 * t * t * t + b
	else
		t = t - 2
		return c / 2 * (t * t * t + 2) + b
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.OutInCubic(t, b, c, d)
	if t < d / 2 then
		return M.OutCubic(t * 2, b, c / 2, d)
	else
		return M.InCubic((t * 2) - d, b + c / 2, c / 2, d)
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.InQuart(t, b, c, d)
	t = t / d
	return c * pow(t, 4) + b
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.OutQuart(t, b, c, d)
	t = t / d - 1
	return -c * (pow(t, 4) - 1) + b
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.InOutQuart(t, b, c, d)
	t = t / d * 2
	if t < 1 then
		return c / 2 * pow(t, 4) + b
	else
		t = t - 2
		return -c / 2 * (pow(t, 4) - 2) + b
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.OutInQuart(t, b, c, d)
	if t < d / 2 then
		return M.OutQuart(t * 2, b, c / 2, d)
	else
		return M.InQuart((t * 2) - d, b + c / 2, c / 2, d)
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.InQuint(t, b, c, d)
	t = t / d
	return c * pow(t, 5) + b
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.OutQuint(t, b, c, d)
	t = t / d - 1
	return c * (pow(t, 5) + 1) + b
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.InOutQuint(t, b, c, d)
	t = t / d * 2
	if t < 1 then
		return c / 2 * pow(t, 5) + b
	else
		t = t - 2
		return c / 2 * (pow(t, 5) + 2) + b
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.OutInQuint(t, b, c, d)
	if t < d / 2 then
		return M.OutQuint(t * 2, b, c / 2, d)
	else
		return M.InQuint((t * 2) - d, b + c / 2, c / 2, d)
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.InSine(t, b, c, d)
	return -c * cos(t / d * (pi / 2)) + c + b
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.OutSine(t, b, c, d)
	return c * sin(t / d * (pi / 2)) + b
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.InOutSine(t, b, c, d)
	return -c / 2 * (cos(pi * t / d) - 1) + b
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.OutInSine(t, b, c, d)
	if t < d / 2 then
		return M.OutSine(t * 2, b, c / 2, d)
	else
		return M.InSine((t * 2) - d, b + c / 2, c / 2, d)
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.InExpo(t, b, c, d)
	if t == 0 then
		return b
	else
		return c * pow(2, 10 * (t / d - 1)) + b - c * 0.001
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.OutExpo(t, b, c, d)
	if t == d then
		return b + c
	else
		return c * 1.001 * (-pow(2, -10 * t / d) + 1) + b
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.InOutExpo(t, b, c, d)
	if t == 0 then
		return b
	end
	if t == d then
		return b + c
	end
	t = t / d * 2
	if t < 1 then
		return c / 2 * pow(2, 10 * (t - 1)) + b - c * 0.0005
	else
		t = t - 1
		return c / 2 * 1.0005 * (-pow(2, -10 * t) + 2) + b
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.OutInExpo(t, b, c, d)
	if t < d / 2 then
		return M.OutExpo(t * 2, b, c / 2, d)
	else
		return M.InExpo((t * 2) - d, b + c / 2, c / 2, d)
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.InCirc(t, b, c, d)
	t = t / d
	return (-c * (sqrt(1 - pow(t, 2)) - 1) + b)
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.OutCirc(t, b, c, d)
	t = t / d - 1
	return (c * sqrt(1 - pow(t, 2)) + b)
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.InOutCirc(t, b, c, d)
	t = t / d * 2
	if t < 1 then
		return -c / 2 * (sqrt(1 - t * t) - 1) + b
	else
		t = t - 2
		return c / 2 * (sqrt(1 - t * t) + 1) + b
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.OutInCirc(t, b, c, d)
	if t < d / 2 then
		return M.OutCirc(t * 2, b, c / 2, d)
	else
		return M.InCirc((t * 2) - d, b + c / 2, c / 2, d)
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.InElastic(t, b, c, d, a, p)
	if t == 0 then
		return b
	end

	t = t / d

	if t == 1 then
		return b + c
	end

	if not p then
		p = d * 0.3
	end

	local s

	if not a or a < abs(c) then
		a = c
		s = p / 4
	else
		s = p / (2 * pi) * asin(c / a)
	end

	t = t - 1

	return -(a * pow(2, 10 * t) * sin((t * d - s) * (2 * pi) / p)) + b
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@param a number Amplitude
---@param p number Period
---@return number Eased Eased value
function M.OutElastic(t, b, c, d, a, p)
	if t == 0 then
		return b
	end

	t = t / d

	if t == 1 then
		return b + c
	end

	if not p then
		p = d * 0.3
	end

	local s

	if not a or a < abs(c) then
		a = c
		s = p / 4
	else
		s = p / (2 * pi) * asin(c / a)
	end

	return a * pow(2, -10 * t) * sin((t * d - s) * (2 * pi) / p) + c + b
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@param a number Amplitude
---@param p number Period
---@return number Eased Eased value
function M.InOutElastic(t, b, c, d, a, p)
	if t == 0 then
		return b
	end

	t = t / d * 2

	if t == 2 then
		return b + c
	end

	if not p then
		p = d * (0.3 * 1.5)
	end
	if not a then
		a = 0
	end

	local s

	if not a or a < abs(c) then
		a = c
		s = p / 4
	else
		s = p / (2 * pi) * asin(c / a)
	end

	if t < 1 then
		t = t - 1
		return -0.5 * (a * pow(2, 10 * t) * sin((t * d - s) * (2 * pi) / p)) + b
	else
		t = t - 1
		return a * pow(2, -10 * t) * sin((t * d - s) * (2 * pi) / p) * 0.5 + c + b
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@param a number Amplitude
---@param p number Period
---@return number Eased Eased value
function M.OutInElastic(t, b, c, d, a, p)
	if t < d / 2 then
		return M.OutElastic(t * 2, b, c / 2, d, a, p)
	else
		return M.InElastic((t * 2) - d, b + c / 2, c / 2, d, a, p)
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.InBack(t, b, c, d, s)
	if not s then
		s = 1.70158
	end
	t = t / d
	return c * t * t * ((s + 1) * t - s) + b
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.OutBack(t, b, c, d, s)
	if not s then
		s = 1.70158
	end
	t = t / d - 1
	return c * (t * t * ((s + 1) * t + s) + 1) + b
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.InOutBack(t, b, c, d, s)
	if not s then
		s = 1.70158
	end
	s = s * 1.525
	t = t / d * 2
	if t < 1 then
		return c / 2 * (t * t * ((s + 1) * t - s)) + b
	else
		t = t - 2
		return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.OutInBack(t, b, c, d, s)
	if t < d / 2 then
		return M.OutBack(t * 2, b, c / 2, d, s)
	else
		return M.InBack((t * 2) - d, b + c / 2, c / 2, d, s)
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.OutBounce(t, b, c, d)
	t = t / d
	if t < 1 / 2.75 then
		return c * (7.5625 * t * t) + b
	elseif t < 2 / 2.75 then
		t = t - (1.5 / 2.75)
		return c * (7.5625 * t * t + 0.75) + b
	elseif t < 2.5 / 2.75 then
		t = t - (2.25 / 2.75)
		return c * (7.5625 * t * t + 0.9375) + b
	else
		t = t - (2.625 / 2.75)
		return c * (7.5625 * t * t + 0.984375) + b
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.InBounce(t, b, c, d)
	return c - M.OutBounce(d - t, 0, c, d) + b
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.InOutBounce(t, b, c, d)
	if t < d / 2 then
		return M.InBounce(t * 2, 0, c, d) * 0.5 + b
	else
		return M.OutBounce(t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b
	end
end

---@param t number Time/Value, goes from 0 to "d" (Duration)
---@param b number Begin/Start
---@param c number Change/End
---@param d number Duration
---@return number Eased Eased value
function M.OutInBounce(t, b, c, d)
	if t < d / 2 then
		return M.OutBounce(t * 2, b, c / 2, d)
	else
		return M.InBounce((t * 2) - d, b + c / 2, c / 2, d)
	end
end

return M
