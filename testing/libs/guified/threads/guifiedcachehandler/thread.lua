--* love2d stuff
require("love.timer")

local threadcomm = love.thread.getChannel("cachehandlerCOMM")
local dbloc = threadcomm:pop()

while dbloc == nil do
    dbloc = threadcomm:pop()
end

local dbname = threadcomm:pop()
while dbname == nil do
    dbname = threadcomm:pop()
end

---@type Database
local db = require(dbname)
while db.db.dbExists(dbname) == false or db.db.tableExists(dbname, "cache") == false do
    --? wait for the db and tabke to be created by the main thread
end
local json = require(dbloc..".json.json") --? hook to json

--* main loop
while true do
    local cmd = threadcomm:pop()
    if cmd ~= nil then
    else
        love.timer.sleep(0.1) --? dont crash
    end
end
