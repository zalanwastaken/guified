-- Requires necessary LOVE2D modules for threading and timing.
require("love.thread")
require("love.timer")

--- The name of the log file to write to.
local LOGFILENAME = "log.log"

--- The channel used to communicate log data between threads.
local datastack = love.thread.getChannel("loggerdata")

-- Check if the log file exists; if not, create it.
if not love.filesystem.getInfo(LOGFILENAME) then
    love.filesystem.newFile(LOGFILENAME) -- Create a new log file if it doesn't exist.
end

-- Write an initial log entry indicating the logger has been initialized.
love.filesystem.write(LOGFILENAME, "LOGGER INIT " .. os.time())

-- Main logging loop
while true do
    --- Retrieve the next message from the datastack channel.
    ---@type string|nil
    local data = datastack:pop() -- Non-blocking pop to get log data.
    
    if data ~= nil then
        if data == "STOP" then
            -- If a "STOP" signal is received, log the shutdown time and exit the loop.
            love.filesystem.write(LOGFILENAME, love.filesystem.read(LOGFILENAME) .. "\n" .. "LOGGER STOPPED " .. os.time())
            break
        else
            -- Otherwise, log the received message and print it to the console.
            print(data)
            love.filesystem.write(LOGFILENAME, love.filesystem.read(LOGFILENAME) .. "\n" .. data)
        end
    else
        -- Sleep briefly to avoid busy-waiting when there are no messages.
        love.timer.sleep(0.01)
    end
end
