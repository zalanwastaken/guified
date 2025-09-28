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
local logger = {
    channel = love.thread.getChannel("loggerdata"),
    thread = love.thread.newThread(string.gsub(__GUIFIEDGLOBAL__.rootfolder..".dependencies.logger.thread", "[.]", "/")..".lua")
}

logger.startSVC = function()
    if not(logger.thread:isRunning()) then
        logger.thread:start()
    end
end

logger.stopSVC = function()
    if logger.thread:isRunning() then
        logger.channel:push("STOP\n\n")
    end
end

--* build logtypes
for k, v in pairs(logtypes) do
    logger[k] = function(X)
        logger.channel:push("\x1B[38;5;10m ["..os.date('%Y-%m-%d %H:%M:%S').."]"..v.." ["..k:upper().."] "..X)
    end
end

return logger
