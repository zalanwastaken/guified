--[[
! NOTE
* The DB system is adapted from myDB at https://github.com/zalanwastaken/myDB by Zalanwastaken
* -Zalanwastaken
--]]

---Gets the script folder path.
---@return string Path of the script folder.
local function getScriptFolder()
	return (debug.getinfo(1, "S").source:sub(2):match("(.*/)"))
end

local json = require(getScriptFolder() .. "/json/json") --* Provides json.encode and json.decode

--* FUNCS

---Checks if a table contains a value.
---@param table table The table to search in.
---@param value any The value to search for.
---@return boolean True if the table contains the value, otherwise false.
local function contains(table, value)
	for _, v in ipairs(table) do
		if v == value then
			return true
		end
	end
	return false
end

---Checks if a table is an array.
---@param tbl table The table to check.
---@return boolean True if the table is an array, otherwise false.
local function isArray(tbl)
	local maxIndex = 0
	local count = 0
	for k, _ in pairs(tbl) do
		if type(k) == "number" then
			maxIndex = math.max(maxIndex, k)
			count = count + 1
		else
			return false -- Found a non-numeric key, so it's not an array
		end
	end
	return maxIndex == count -- Ensure there are no gaps in numeric keys
end

---Merges two dictionaries or arrays.
---@param t1 table The first table.
---@param t2 table The second table.
---@return table The merged table.
local function mergeDicts(t1, t2)
	if isArray(t1) and isArray(t2) then
		local result = {}
		for _, v in ipairs(t1) do
			table.insert(result, v)
		end
		for _, v in ipairs(t2) do
			table.insert(result, v)
		end
		return result
	else
		local result = {}
		for k, v in pairs(t1) do
			result[k] = v
		end
		for k, v in pairs(t2) do
			result[k] = v
		end
		return result
	end
end

---Gets database information from the info.json file.
---@param dbname string The database name.
---@return table|nil The database info or nil if not found.
local function getdbinfo(dbname)
	if love.filesystem.getInfo(dbname) then
		return (json.decode(love.filesystem.read(dbname .. "/info.json")))
	else
		return nil
	end
end

---Saves database information to the info.json file.
---@param dbname string The database name.
---@param info table The database info to save.
local function savedbinfo(dbname, info)
	if love.filesystem.getInfo(dbname) then
		love.filesystem.write(dbname .. "/info.json", json.encode(info))
	end
end

---Removes the file extension from a filename.
---@param filename string The filename.
---@return string The filename without the extension.
local function removeFileExtension(filename)
	return filename:match("(.+)%.[^%.]+$") or filename
end

---Checks if a file is a JSON file.
---@param filename string The filename to check.
---@return boolean True if the file is a JSON file, otherwise false.
local function isJsonFile(filename)
	return filename:lower():match("%.json$") ~= nil
end

---Gets all keys from a table.
---@param tbl table The table.
---@return table A list of keys from the table.
local function getKeys(tbl)
	local keys = {}
	for key, _ in pairs(tbl) do
		table.insert(keys, key)
	end
	return keys
end

--* CODE

---@class Database
local DB = {
	db = {
		---Creates a new database.
		---@param dbname string The name of the database.
		createDB = function(dbname)
			if not (love.filesystem.getInfo(dbname)) then
				love.filesystem.createDirectory(dbname)
				love.filesystem.newFile(dbname .. "info.json")
				love.filesystem.write(
					dbname .. "/info.json",
					json.encode({
						name = dbname,
						TOC = os.date(), --? Time of creation
						tables = {},
					})
				)
			else
				error("DB " .. dbname .. " already exists")
			end
		end,

		---Creates a new table in a database.
		---@param dbname string The database name.
		---@param tablename string The table name.
		---@param data table The initial data for the table.
		createTable = function(dbname, tablename, data)
			if love.filesystem.getInfo(dbname) then
				local info = getdbinfo(dbname)
				if type(data):lower() == "table" then
					if not (contains(info.tables, tablename)) then
						love.filesystem.newFile(dbname .. "/" .. tablename .. ".json")
						love.filesystem.write(dbname .. "/" .. tablename .. ".json", json.encode(data))
						info.tables[#info.tables + 1] = tablename
						savedbinfo(dbname, info)
					else
						error("Table " .. tablename .. " already exists !")
					end
				end
			end
		end,

		---Gets table data from a database.
		---@param dbname string The database name.
		---@param tablename string The table name.
		---@return table|nil The table data or nil if not found.
		getTableData = function(dbname, tablename)
			if love.filesystem.getInfo(dbname) then
				local info = getdbinfo(dbname)
				if contains(info.tables, tablename) then
					return (json.decode(love.filesystem.read(dbname .. "/" .. tablename .. ".json")))
				end
			end
		end,

		---Gets database information.
		---@param dbname string The database name.
		---@return table|nil The database info or nil if not found.
		getDbInfo = function(dbname)
			if love.filesystem.getInfo(dbname) then
				return (getdbinfo(dbname))
			end
		end,

		---Modifies an existing table in a database.
		---@param dbname string The database name.
		---@param tablename string The table name.
		---@param data table The data to merge with the existing table data.
		modifyTable = function(dbname, tablename, data)
			if love.filesystem.getInfo(dbname) then
				local info = getdbinfo(dbname)
				if contains(info.tables, tablename) then
					love.filesystem.write(
						dbname .. "/" .. tablename .. ".json",
						json.encode(
							mergeDicts(json.decode(love.filesystem.read(dbname .. "/" .. tablename .. ".json")), data)
						)
					)
				end
			end
		end,

		---Checks if a table exists in a database.
		---@param dbname string The database name.
		---@param tablename string The table name.
		---@return boolean True if the table exists, otherwise false.
		tableExists = function(dbname, tablename)
			if love.filesystem.getInfo(dbname) then
				if love.filesystem.getInfo(dbname .. "/" .. tablename .. ".json") then
					return true
				else
					return false
				end
			end
		end,

		---Checks if a database exists.
		---@param dbname string The database name.
		---@return boolean True if the database exists, otherwise false.
		dbExists = function(dbname)
			if love.filesystem.getInfo(dbname) then
				return true
			else
				return false
			end
		end,

		---Creates a structured table in a database.
		---@param dbname string The database name.
		---@param tablename string The table name.
		---@param struct table The structure of the table.
		createStructTable = function(dbname, tablename, struct)
			local info = getdbinfo(dbname)
			if info ~= nil then
				if contains(info.tables, tablename) ~= true then
					info.tables[#info.tables + 1] = tablename
					savedbinfo(dbname, info)
					love.filesystem.newFile(dbname .. "/" .. tablename .. ".json")
					struct = { struct = struct, data = {} }
					--print(json.encode(struct))
					love.filesystem.write(dbname .. "/" .. tablename .. ".json", json.encode(struct))
				else
					error("Table " .. tablename .. " does already exist in DB " .. dbname)
				end
			else
				error("DB " .. dbname .. " does not exist")
			end
		end,

		---Adds data to a structured table in a database.
		---@param dbname string The database name.
		---@param tablename string The table name.
		---@param vals table The values to add to the table.
		addStructData = function(dbname, tablename, vals)
			local info = getdbinfo(dbname)
			if getdbinfo ~= nil then
				if contains(info.tables, tablename) then
					local table = json.decode(love.filesystem.read(dbname .. "/" .. tablename .. ".json"))
					local structkeys = table.struct
					local valskeys = getKeys(vals)
					local function chkkey(key, tbl)
						for i = 1, #tbl, 1 do
							if tbl[i] == key then
								return true
							end
						end
						return false
					end
					for i = 1, #valskeys, 1 do
						if not (chkkey(valskeys[i], structkeys)) then
							error("Key error at pos " .. tostring(i))
						end
					end
					table.data[#table.data + 1] = vals
					love.filesystem.write(dbname .. "/" .. tablename .. ".json", json.encode(table))
				else
					error("Table " .. tablename .. " does not exist in DB " .. dbname)
				end
			else
				error("DB " .. dbname .. " does not exist")
			end
		end,

		---Gets data from a structured table in a database.
		---@param dbname string The database name.
		---@param tablename string The table name.
		---@param sno number|nil The serial number of the data to retrieve (optional).
		---@return table|nil The table data or nil if not found.
		getStructData = function(dbname, tablename, sno)
			local info = getdbinfo(dbname)
			if info ~= nil then
				if contains(info.tables, tablename) then
					local table = json.decode(love.filesystem.read(dbname .. "/" .. tablename .. ".json"))
					if sno == nil then
						return table.data
					else
						return table.data[sno]
					end
				else
					error("Table " .. tablename .. " does not exist in DB " .. dbname)
				end
			else
				error("DB " .. dbname .. " does not exist")
			end
		end,
	},

	fs = {
		---Removes a file from a database.
		---@param dbname string The database name.
		---@param file string The file to remove.
		removeDbFile = function(dbname, file) --! Does NOT update the DB info use with care
			if love.filesystem.getInfo(dbname) then
				if love.filesystem.getInfo(dbname .. "/" .. file) then
					love.filesystem.remove(dbname .. "/" .. file)
				end
			end
		end,

		---Fixes the table information in the database info.json file.
		---@param dbname string The database name.
		fixTableInfo = function(dbname)
			local info = getdbinfo(dbname)
			if info ~= nil then
				local files = love.filesystem.getDirectoryItems(dbname)
				info.tables = {}
				for i = 1, #files, 1 do
					if files[i] ~= "info.json" and isJsonFile(files[i]) then
						info.tables[#info.tables + 1] = removeFileExtension(files[i])
					end
				end
				savedbinfo(dbname, info)
			end
		end,
	},
}

return DB
