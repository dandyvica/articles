// simple malloc/free calls
// compile with gcc -g -D_GNU_SOURCE -shared my_alloc.c -o my_alloc.so

#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <dlfcn.h>

static void* (*guenuine_malloc)(size_t size);

void *malloc(size_t size) {
    // get handle on libc
    //printf("before dlopen()");    
    //void *libc = dlopen("/lib/x86_64-linux-gnu/libc.so.6",RTLD_LAZY);

    // load real malloc from libc
    //printf("before guenuine_malloc()");
    guenuine_malloc = dlsym(RTLD_NEXT, "malloc");

    return guenuine_malloc(size);
}
