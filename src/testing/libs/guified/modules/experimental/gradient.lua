---@class gradient
local gradient = {
    newGradient = function(self, clr1, clr2, w, h)
        local data = {
            bigger = {},
            diff = {},
            clrdata = love.image.newImageData(100, 100)
        }

        for i = 0, 100-1, 1 do
            for f = 0, 100-1, 1 do
                data.clrdata:setPixel(i, f, 1, 1, 1, 1)
            end
        end

        data.clrdata = love.graphics.newImage(data.clrdata)
        return({
            name = "gradient SVC",
            draw = function()
                love.graphics.draw(data.clrdata, 0, 0)
            end
        })
    end
}
return(gradient)
