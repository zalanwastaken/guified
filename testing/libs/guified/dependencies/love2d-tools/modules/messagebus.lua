---@param length number The desired length of the generated ID (default is 16).
---@return string A randomly generated ID of the specified length.
local function idgen(length)
	length = length or 16
	local chars = { -- * Small chars
		"a",
		"b",
		"c",
		"d",
		"e",
		"f",
		"g",
		"h",
		"i",
		"j",
		"k",
		"l",
		"m",
		"n",
		"o",
		"p",
		"q",
		"r",
		"s",
		"t",
		"u",
		"v",
		"w",
		"x",
		"y",
		"z", -- * Capital chars
		"A",
		"B",
		"C",
		"D",
		"E",
		"F",
		"G",
		"H",
		"I",
		"J",
		"K",
		"L",
		"M",
		"N",
		"O",
		"P",
		"Q",
		"R",
		"S",
		"T",
		"U",
		"V",
		"W",
		"X",
		"Y",
		"Z", -- * Numbers
		"0",
		"1",
		"2",
		"3",
		"4",
		"5",
		"6",
		"7",
		"8",
		"9", -- * Special chars
		"!",
		"@",
		"#",
		"$",
		"%",
		"^",
		"&",
		"*",
		"(",
		")",
		"-",
		"_",
		"=",
		"+",
		"{",
		"}",
		"[",
		"]",
		":",
		";",
		"'",
		"<",
		">",
		",",
		".",
		"?",
		"/",
	}
	local ret = ""
	for i = 1, length, 1 do
		ret = ret .. chars[love.math.random(1, #chars)]
	end
	return ret
end
---@param table table The table to search.
---@param value any The value to check for in the table.
---@return boolean Whether the value exists in the table.
local function contains(table, value)
	for _, v in ipairs(table) do
		if v == value then
			return true
		end
	end
	return false
end

local businternal = {
	ids = {},
	messages = {},
}
---@class messageBus
local bus = {
	---@param idlen? number The length of the subscription point ID (default is 16).
	---@return table A subscription point object with an ID and a method to retrieve messages.
	newSubPoint = function(idlen)
		idlen = idlen or 16
		local id = idgen(idlen)
		businternal.ids[#businternal.ids + 1] = id
		local ret = {
			id = id,
			---@param type string|nil The type of message to retrieve ("broadcast" or nil).
			---@return any The content of the retrieved message or nil if none found.
			getMsg = function(type)
				if type == nil then
					for i = 1, #businternal.messages, 1 do
						if businternal.messages[i].id == id then
							local content = businternal.messages[i].content
							table.remove(businternal.messages, i)
							return content
						end
					end
				elseif type == "broadcast" then
					for i = 1, #businternal.messages, 1 do
						if businternal.messages[i].id == "ALL" then
							local content = businternal.messages[i].content
							return content
						end
					end
				end
			end,
		}
		return ret
	end,
	---@param id string The ID of the recipient subscription point.
	---@param content any The message content to send.
	sendMessage = function(id, content)
		if contains(businternal.ids, id) then
			businternal.messages[#businternal.messages + 1] = {
				id = id,
				content = content,
			}
		end
	end,
	---@param content any The content to broadcast to all subscription points.
	---@return table An object with a position and a method to end the broadcast.
	broadcast = function(content)
		local ourpos = #businternal.messages + 1
		businternal.messages[#businternal.messages + 1] = {
			id = "ALL",
			content = content,
		}
		return {
			pos = ourpos,
			---@return nil Ends the broadcast and removes it from the message queue.
			endbrodcast = function()
				local index = 0
				for i = 1, #businternal.messages, 1 do
					if businternal.messages[i].content == content then
						index = i
						break
					end
				end
				table.remove(businternal.messages, index)
			end,
		}
	end,
}

return bus
