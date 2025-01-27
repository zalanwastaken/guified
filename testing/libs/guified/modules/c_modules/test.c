#include<lua.h>
#include<stdio.h>

int luaopen_libs_guified_modules_c_modules_test(lua_State *l){
    printf("Hello World !\n", __FUNCTION__);
    return 0;
}
