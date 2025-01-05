---@class TableExtension
local M = {}

---Insert all the module's methods to a table. All methods will start with *"_"*.
---With all the methods inside the table, call them with a colon *(:)* to make the first argument
---*(*`tabl`*)* be the table. e.g `Table:ForEach(print)` instead of `Table.ForEach(Table, print)`.
---
---**Warning: This can affect performance. Use wisely.**
---@param tabl table Table
---@return table Table For chaining
function M:InsertMethods(tabl)
	for k, method in pairs(self) do
		tabl["_" .. k] = method
	end
	return tabl
end

---For each element in a table calls `func` with arguments:
--- - Element.
--- - All arguments given after `func`.
---@param tabl table Table
---@param func function Called function
---@param ...? any Arguments
---@return table Table For chaining
function M.ForEach(tabl, func, ...)
	local args = { ... }
	for _, v in pairs(tabl) do
		func(v, unpack(args))
	end
	return tabl
end

---Returns index of `val` in `tabl`.
---@param tabl table Table
---@param val any Value
---@return nil|integer Index `nil` if value was not found
---@return table Table For chaining
function M.IndexOf(tabl, val)
	for i, v in ipairs(tabl) do
		if v == val then
			return i, tabl
		end
	end
	return nil, tabl
end

---Returns key of `val` in `tabl`.
---@param tabl table Table
---@param val any Value
---@return nil|string Key `nil` if value was not found
---@return table Table For chaining
function M.KeyOf(tabl, val)
	for k, v in pairs(tabl) do
		if v == val then
			return k, tabl
		end
	end
	return nil, tabl
end

---Returns all elements from `i` to `j` from `tabl`.
---@param tabl table Table
---@param i integer Position 1
---@param j integer Position 2
---@return table Selection Selected elements
---@return table Table For chaining
function M.Select(tabl, i, j)
	local selection = {}
	for indx = i, j do
		local curr = tabl[indx]
		if curr then
			table.insert(selection, curr)
		else
			break
		end
	end
	return selection, tabl
end

---Merge table `a` with table `b`.
---@param a table First table
---@param b table Second table
---@return table Merged Merged tables
---@return table Table First table. For chaining.
function M.Merge(a, b)
	local merged = {}
	for k, v in pairs(a) do
		merged[k] = v
	end
	for k, v in pairs(b) do
		merged[k] = v
	end
	return merged, a
end

---Insert an element **only if it isn't inside the table already**.
---@param tabl table Table
---@param val any Value
---@return boolean Succes False if it was inside the table already
---@return table Table For chaining
function M.InsertWithoutDuplicate(tabl, val)
	if M.IndexOf(tabl, val) then
		return false, tabl
	end
	table.insert(tabl, val)
	return true, tabl
end

---Returns all the keys of a table.
---@param tabl table Table
---@return table Keys Table's keys
---@return table Table For chaining
function M.Keys(tabl)
	local keys = {}
	for k in pairs(tabl) do
		table.insert(keys, k)
	end
	return keys, tabl
end

---Create a shallow copy (only top level and its children) of the table with the same metatable.
---@param tabl table Table to copy
---@return table Copy Copied table
---@return table Table For chaining
function M.ShallowCopy(tabl)
	local copy = {}
	for k, v in pairs(tabl) do
		copy[k] = v
	end
	copy = setmetatable(copy, tabl) --set the same metatable
	return copy, tabl
end

---Create a deep copy (all levels) of the table with the same metatable.
---
---**Warning: This can affect performance heavily with large tables, as it operates recursively**.
---@param tabl table Table to copy
---@return table Copy Copied table
---@return table Table For chaining
function M.DeepCopy(tabl)
	local copy = {}
	for k, v in pairs(tabl) do
		local v_type = type(v)
		if v_type == "table" then
			copy[k] = setmetatable(M.DeepCopy(v), v)
		else
			copy[k] = v
		end
	end
	copy = setmetatable(copy, tabl) --set the same metatable
	return copy, tabl
end

return M
