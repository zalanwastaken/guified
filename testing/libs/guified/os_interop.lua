--! LINUX IS BROKEN
local os = love.system.getOS():lower()
local ffi = require("ffi")
local x11

if os == "linux" then
    x11 = ffi.load("X11")  -- Load X11 library only once for Linux
end

if os == "windows" then
    ffi.cdef [[
        //! C code
        typedef void* HWND;
        HWND FindWindowA(const char* lpClassName, const char* lpWindowName);
        int SetWindowPos(HWND hWnd, HWND hWndInsertAfter, int X, int Y, int cx, int cy, unsigned int uFlags);
        static const unsigned int SWP_NOSIZE = 0x0001;
        static const unsigned int SWP_NOMOVE = 0x0002;
        static const unsigned int SWP_SHOWWINDOW = 0x0040;
        short GetKeyState(int nVirtKey);
    ]]
elseif os == "linux" then
    ffi.cdef [[
        typedef struct _XDisplay Display;
        typedef unsigned long Window;
        typedef unsigned long Atom;
        typedef int Status;

        Display* XOpenDisplay(const char* display_name);
        int XCloseDisplay(Display* display);
        Window XDefaultRootWindow(Display* display);
        Status XQueryTree(Display* display, Window w, Window* root_return, Window* parent_return, Window** children_return, unsigned int* nchildren_return);
        Status XFetchName(Display* display, Window w, char** window_name_return);
        Atom XInternAtom(Display* display, const char* atom_name, int only_if_exists);
        void XChangeProperty(Display* display, Window w, Atom property, Atom type, int format, int mode, const unsigned char* data, int nelements);
        void XFlush(Display* display);
        void XFree(void* data);
    ]]
end

local function findWindowByTitle(title)
    print("Searching for window with title: " .. title)  -- Debugging line

    local display = x11.XOpenDisplay(nil)
    if display == nil then
        print("Unable to open X11 display!")
        return nil
    end

    local root = x11.XDefaultRootWindow(display)
    local root_return = ffi.new("Window[1]")
    local parent_return = ffi.new("Window[1]")
    local children_return = ffi.new("Window*[1]")
    local nchildren_return = ffi.new("unsigned int[1]")

    if x11.XQueryTree(display, root, root_return, parent_return, children_return, nchildren_return) == 0 then
        x11.XCloseDisplay(display)
        print("Unable to query window tree")
        return nil
    end

    local children = children_return[0]
    local nchildren = nchildren_return[0]

    -- Iterate over the children windows
    for i = 0, nchildren - 1 do
        local child = children[i]
        local name = ffi.new("char*[1]")
        if x11.XFetchName(display, child, name) ~= 0 then
            local window_name = ffi.string(name[0])
            x11.XFree(name[0])

            -- Print the window title to debug
            print("Window found: " .. window_name)

            -- Compare case-insensitively
            if window_name:lower() == title:lower() then
                x11.XFree(children)
                x11.XCloseDisplay(display)
                return child -- Return the window handle
            end
        else
            -- Print if window name fetching fails
            print("Failed to fetch window name for window ID: " .. tostring(child))
        end
    end

    -- Clean up
    x11.XFree(children)
    x11.XCloseDisplay(display)

    -- Window not found
    print("Window with title '" .. title .. "' not found.")
    return nil
end

local ret = {
    setWindowToBeOnTop = function(title, noerr)
        if os == "windows" then
            local HWND_TOPMOST = ffi.cast("HWND", -1)
            local HWND_NOTOPMOST = ffi.cast("HWND", -2)
            local hwnd = ffi.C.FindWindowA(nil, title)
            if hwnd == nil then
                print("HWND not found!")
                if noerr then
                    return false
                else
                    error("HWND not found !")
                end
            else
                print("Found window handle:", hwnd)
                -- * Set the window to always be on top
                ffi.C.SetWindowPos(hwnd, HWND_TOPMOST, 0, 0, 0, 0,
                    ffi.C.SWP_NOSIZE + ffi.C.SWP_NOMOVE + ffi.C.SWP_SHOWWINDOW)
                print("Window set to always on top.")
                if noerr then
                    return true
                end
            end
        elseif os == "linux" then
            local targetWindow = findWindowByTitle(title)

            if not targetWindow then
                print("Window not found!")
                if noerr then
                    return false
                else
                    error("Window not found!")
                end
            end

            -- Set the window to always be on top
            local display = x11.XOpenDisplay(nil)
            local atomState = x11.XInternAtom(display, "_NET_WM_STATE", false)
            local atomAbove = x11.XInternAtom(display, "_NET_WM_STATE_ABOVE", false)

            local data = ffi.new("Atom[1]", atomAbove)
            x11.XChangeProperty(display, targetWindow, atomState, ffi.C.XA_ATOM, 32, ffi.C.PropModeReplace,
                ffi.cast("unsigned char*", data), 1)

            x11.XFlush(display)
            x11.XCloseDisplay(display)
            print("Window set to always on top.")
            return true
        end
    end
}

return ret
