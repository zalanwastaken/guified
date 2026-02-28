local guified = require("guified")
local logger = guified.debug.logger

local properties = {
    -- * Inits the property system for a element
    -- ! This must be run on a element before adding properties to it
    ---@param element element
    initPropertySys = function(element)
        local mt = {
            __index = {},
            __newindex = function(tbl, key, val)
                local mt = getmetatable(tbl)
                if mt.__index[key] then
                    mt.__index[key] = val
                    mt.funcs[key](val)
                else
                    rawset(tbl, key, val) -- ? rawset so we dont cause stack overflow
                end
            end,
            funcs = {}
        }
        setmetatable(element, mt)

        logger.info("property system init for " .. element._guified.name .. ":" .. (element._guified.id or ""))
    end,

    -- * adds a property to a element
    ---@param element element
    ---@param property string
    ---@param initialVAL any
    ---@param onchange function
    newProperty = function(element, property, initialVAL, onchange)
        local mt = getmetatable(element)
        mt.__index[property] = initialVAL
        mt.funcs[property] = onchange

        logger.info("property added in element" .. element._guified.name .. ":" .. (element._guified.id or ""))
    end,

    -- * returns the value of a property
    ---@param element element
    getProperty = function(element, property)
        return getmetatable(element).__index[property]
    end,

    -- * returns all properties as a dict.
    ---@param element element
    getAllProperties = function(element)
        return getmetatable(element).__index
    end,

    -- * removes a property from a element
    ---@param element element
    ---@param property string
    removeProperty = function(element, property)
        local mt = getmetatable(element)
        mt.__index[property] = nil
        mt.funcs[property] = nil

        logger.info("removed property from element " .. element._guified.name .. ":" .. (element._guified.id or ""))
    end,

    ---@param element element
    deInitPropertySys = function(element)
        setmetatable(element, nil) -- yeet the mt >:D
    end
}

return properties
