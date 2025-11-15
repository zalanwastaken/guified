local loudErrors = false
local filter = {}

local logtypes = {
    info = "\x1B[38;5;7m",
    error = "\x1B[38;5;9m",
    ok = "\x1B[38;5;10m",
    trace = "\x1B[38;5;13m",
    fatal = "\x1B[38;5;12m",
    warn = "\x1B[38;5;11m",
    regular = "\x1B[38;5;15m",
    debug = "\x1B[38;5;7m"
}

---@class logger
local logger = {}

---@class guifiedloggerinterface
local guifiedloggerinterface = {
    ---@param set boolean
    setLoudErrors = function(set)
        loudErrors = set or false
    end,
    setfilter = function(argfilter)
        for i = 1, #argfilter, 1 do
            filter[argfilter[i]] = true
        end
    end,
    channel = love.thread.getChannel("loggerdata"),
    thread = love.thread.newThread(string.gsub(__GUIFIEDGLOBAL__.rootfolder..".dependencies.logger.thread", "[.]", "/")..".lua")
}

guifiedloggerinterface.startSVC = function()
    if not(guifiedloggerinterface.thread:isRunning()) then
        guifiedloggerinterface.thread:start()
    end
end

guifiedloggerinterface.stopSVC = function()
    if guifiedloggerinterface.thread:isRunning() then
        guifiedloggerinterface.channel:push("STOP\n\n")
        guifiedloggerinterface.thread:wait()
    end
end

--* build logtypes
for k, v in pairs(logtypes) do
    logger[k] = function(X)
        if not(filter[k] == true) then
            guifiedloggerinterface.channel:push("\x1B[38;5;10m ["..os.date('%Y-%m-%d %H:%M:%S').."]"..v.." ["..k:upper().."] "..X)
            if k == "error" and loudErrors then
                guifiedloggerinterface.channel:push("\x1B[38;5;10m ["..os.date('%Y-%m-%d %H:%M:%S').."]"..v.." ["..k:upper().."] [[ERROR UPGRADED TO FATAL BY LOUD ERRORS]]")
                error(X)
            end
        end
    end
end

return {logger = logger, guifiedloggerinterface = guifiedloggerinterface}
