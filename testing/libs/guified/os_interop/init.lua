local logger = require("libs.guified.dependencies.love2d-tools.modules.logger.init")

---@param warnf function
---@return table
local function init_interop(warnf)
    local os = love.system.getOS():lower()
    local ffi = require("ffi")
    if os == "windows" then
        ffi.cdef [[
            //! C code
            typedef void* HWND;
            HWND FindWindowA(const char* lpClassName, const char* lpWindowName);
            int SetWindowPos(HWND hWnd, HWND hWndInsertAfter, int X, int Y, int cx, int cy, unsigned int uFlags);
            static const unsigned int SWP_NOSIZE = 0x0001;
            static const unsigned int SWP_NOMOVE = 0x0002;
            static const unsigned int SWP_SHOWWINDOW = 0x0040;
        ]]
    elseif os == "linux" then
        --warnf("FFI features on Linux are not supported")
    end
    local ret = {}
    if os == "windows" then
        ret = {
            -- Function to modify the existing window
            setWindowToBeOnTop = function(title)
                local HWND_TOPMOST = ffi.cast("HWND", -1)
                local HWND_NOTOPMOST = ffi.cast("HWND", -2)
                local hwnd = ffi.C.FindWindowA(nil, title)
                logger.info("Attempting to get window HWND")
                if hwnd == nil then
                    logger.error("HWND not found !")
                    return(false)
                else
                    logger.info("Found window handle:"..tostring(hwnd))
                    -- * Set the window to always be on top
                    ffi.C.SetWindowPos(hwnd, HWND_TOPMOST, 0, 0, 0, 0,
                        ffi.C.SWP_NOSIZE + ffi.C.SWP_NOMOVE + ffi.C.SWP_SHOWWINDOW)
                    logger.info("Window set to always on top.")
                    return(true)
                end
            end
        }
    elseif os == "linux" then
        ret = {
            setWindowToBeOnTop = function() 
                warnf("FFI features on Linux are not supported")
                logger.error("Attempt to access FFI feature on linux")
                return(false)
            end
        }
    end
    return(ret)
end
return(init_interop)
