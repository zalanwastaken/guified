---@class Class
---@field attributes table Attributes of the class
---@field sub table Subclasses
---@field id string Class's id
local M = {}

---Create new object.
---@param self Class
---@return table
function M.new(self)
	local obj = {}
	for k, v in pairs(self.attributes) do
		obj[k] = v
	end
	obj._is = is
	obj.id = self.id
	return obj
end

---Create sub class.
---@param self Class Parent
---@param name string Name of the subclass
---@param attributes table Attributes of the subclass
---@return Class
function M.extend(self, name, attributes)
	self.sub[name] = NewClass(attributes)
	self.sub[name].id = self.id
	return self.sub[name]
end

---Check if object comes from a Class.
---@param obj table
---@param Class Class
---@return boolean
---@diagnostic disable-next-line: lowercase-global
function is(obj, Class)
	if obj.id == Class.id then
		return true
	else
		return false
	end
end

---Create a copy of the class.
---@param self Class Class to copy
---@return Class Copy Copy of the class
function M.clone(self)
	return NewClass(self.attributes)
end

---Merge with another class.
---@param self Class
---@param Class2 Class Class to merge with
---@return Class
function M.merge(self, Class2)
	local merged = {
		self = self.attributes,
		Class2 = Class2.attributes,
	}
	local final = {}
	for _, Class in pairs(merged) do
		for k, var in pairs(Class) do
			final[k] = var
		end
	end
	return NewClass(final)
end

local function IdGenerator(len)
	local characters = {
		"A",
		"B",
		"C",
		"D",
		"E",
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		0,
	}
	local id = ""
	for _ = 1, len do
		id = id .. tostring(characters[math.random(1, #characters)])
	end
	return id
end

---Create a new Class
---
---Warning: Creates a new id every time it is called, which can affect performance
---significantly
---@param attributes table
---@return Class
function NewClass(attributes)
	local cls = {
		attributes = {},
		sub = {},
		id = IdGenerator(8),
	}
	for k, v in pairs(attributes) do
		cls.attributes[k] = v
	end
	cls.new = M.new
	cls.extend = M.extend
	cls.clone = M.clone
	cls.merge = M.merge
	return cls
end

return NewClass
