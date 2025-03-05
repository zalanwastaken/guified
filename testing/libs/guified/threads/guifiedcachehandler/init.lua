local function getScriptFolder()
    return (debug.getinfo(1, "S").source:sub(2):match("(.*/)"))
end

---@type Database
local db --? init later
local json --? init later
local dbname = "guifiedcache"
---@class cachehandler
local cachehandler = {
    thread = love.thread.newThread(getScriptFolder().."thread.lua"),
    threadcomm = love.thread.getChannel("cachehandlerCOMM"),
}

cachehandler.startSVC = function(dbloc)
    cachehandler.thread:start()
    cachehandler.threadcomm:push(dbloc)
    cachehandler.threadcomm:push(dbname)
    db = require(dbloc)

    --* check for cache db
    if not(db.db.dbExists(dbname)) then
        db.db.createDB(dbname)
    end
    if not(db.db.tableExists(dbname, "cache")) then
        db.db.createStructTable(dbname, "cache", {"key", "val"})
    end
    print(dbloc..".json.json")
    json = require(dbloc..".json.json") --? hook to json
end
cachehandler.write = function(data)
    cachehandler.threadcomm:push(json.encode({
        action = "write",
        data = data
    }))
end

return(cachehandler)
