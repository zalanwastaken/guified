---@class Color
local colors = {
    -- Standard Colors
    black = {0, 0, 0}, -- Solid black
    white = {1, 1, 1}, -- Pure white
    red = {1, 0, 0}, -- Classic red
    green = {0, 1, 0}, -- Straightforward green
    blue = {0, 0, 1}, -- Basic blue
    yellow = {1, 1, 0}, -- Standard yellow
    cyan = {0, 1, 1}, -- Reliable cyan
    magenta = {1, 0, 1}, -- Standard magenta
    grey = {0.5, 0.5, 0.5}, -- Neutral grey
    orange = {1, 0.5, 0}, -- Typical orange
    -- Vibrant Colors
    electric_blue = {0.12, 0.56, 1.0}, -- Bright and punchy blue
    neon_pink = {1.0, 0.08, 0.58}, -- Flashy pink for the bold
    lime_green = {0.5, 1.0, 0.0}, -- In-your-face lime green
    intense_orange = {1.0, 0.5, 0.0}, -- Electric orange to light it up
    acid_yellow = {0.96, 1.0, 0.0}, -- Eye-popping yellow
    vivid_purple = {0.62, 0.0, 1.0}, -- Deep, rich purple
    -- Nature-Inspired Colors
    forest_green = {0.13, 0.55, 0.13}, -- Dark, natural green
    sky_blue = {0.53, 0.81, 0.92}, -- Light sky color
    sea_green = {0.18, 0.55, 0.34}, -- Sea green
    olive_green = {0.5, 0.5, 0}, -- Earthy olive green
    sand = {0.76, 0.7, 0.5}, -- Soft, sandy beige
    rust = {0.72, 0.25, 0.05}, -- Earthy rust tone
    chocolate = {0.82, 0.41, 0.12}, -- Dark, rich chocolate
    mint_green = {0.6, 1.0, 0.6}, -- Fresh, minty green
    -- Pastels
    pastel_pink = {1.0, 0.75, 0.8}, -- Soft, muted pink
    lavender = {0.9, 0.9, 0.98}, -- Pale, gentle lavender
    light_blue = {0.68, 0.85, 0.9}, -- Gentle, soft blue
    peach = {1.0, 0.85, 0.72}, -- Warm peach tone
    blush = {1.0, 0.76, 0.8}, -- Soft blush pink
    periwinkle = {0.8, 0.8, 1.0}, -- Soft, light periwinkle
    -- Metallics and Jewel Tones
    gold = {1.0, 0.84, 0.0}, -- Shiny gold
    amber = {1.0, 0.75, 0.0}, -- Bold amber
    aquamarine = {0.5, 1.0, 0.83}, -- Bright aquamarine
    indigo = {0.29, 0, 0.51}, -- Dark indigo
    teal = {0.0, 0.5, 0.5}, -- Cool, balanced teal
    royal_blue = {0.25, 0.41, 0.88}, -- Rich royal blue
    maroon = {0.5, 0, 0.25}, -- Dark, moody maroon
    plum = {0.56, 0.27, 0.52}, -- Deep plum
    -- Neutrals and Dark Shades
    light_grey = {0.83, 0.83, 0.83}, -- Soft light grey
    slate = {0.44, 0.5, 0.56}, -- Steady slate grey
    navy_blue = {0, 0, 0.5}, -- Dark and steady blue
    dark_red = {0.5, 0, 0}, -- Deep, muted red
    olive_drab = {0.42, 0.56, 0.14}, -- Military-style olive
    deep_purple = {0.4, 0.2, 0.6}, -- Dark, rich purple
    -- Additional Unique Colors
    brick_red = {0.8, 0.25, 0.33}, -- Rustic brick red
    watermelon = {0.99, 0.27, 0.49}, -- Juicy watermelon pink
    turquoise = {0.25, 0.88, 0.82}, -- Vibrant turquoise
    ivory = {1.0, 1.0, 0.94}, -- Soft ivory white
    ochre = {0.8, 0.47, 0.13}, -- Earthy ochre
    sapphire = {0.06, 0.32, 0.73}, -- Deep sapphire blue
    jade = {0.0, 0.66, 0.42}, -- Cool jade green
    rose_gold = {0.72, 0.43, 0.47}, -- Subtle rose gold

    funcs = {
        addAlpha = function(clr, alpha)
            clr[4] = alpha or 0
            return clr
        end,
        checkIfValid = function(clr)
            for i = 1, 3 do
                if type(clr[i]) == "number" then
                    return false
                end
            end
            return true
        end,
        getAlpha = function(clr)
            return clr[4]
        end
    }
}

return (colors)
-- * Guified is more like a color lib with a free element manager
