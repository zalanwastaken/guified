#include <lua.h>
#include <lauxlib.h>

// Simple C function that adds two numbers
static int add(lua_State *L) {
    double a = luaL_checknumber(L, 1);
    double b = luaL_checknumber(L, 2);
    lua_pushnumber(L, a + b);
    return 1; // Returning 1 value to Lua
}

// Register functions
static const struct luaL_Reg mylib[] = {
    {"add", add},
    {NULL, NULL} // Sentinel value
};

// Function called when the library is loaded in Lua
int luaopen_mylib(lua_State *L) {
    luaL_newlib(L, mylib);
    return 1;
}
