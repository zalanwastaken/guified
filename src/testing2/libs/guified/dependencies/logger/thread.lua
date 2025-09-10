local channel = love.thread.getChannel("loggerdata")

local LOGFILE = "log.log"

if not(love.filesystem.getInfo(LOGFILE)) then
    love.filesystem.newFile(LOGFILE)
end

love.filesystem.write(LOGFILE, "LOGGER INIT\n"..os.date('%Y-%m-%d %H:%M:%S').."\n")

while true do
    local data = channel:demand()

    if data == "STOP\n\n" then
        love.filesystem.write(LOGFILE, love.filesystem.read(LOGFILE).."\nLOGGER STOPPED\n"..os.date('%Y-%m-%d %H:%M:%S').."\n")
        break
    end

    love.filesystem.write(LOGFILE, love.filesystem.read(LOGFILE).."\n"..data)
    print(data)
end
