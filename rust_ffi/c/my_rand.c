// simple malloc/free calls
// compile with gcc -g -D_GNU_SOURCE -shared my_alloc.c -o my_alloc.so

#include <stdint.h>
#include <stdlib.h>

int rand(void) {
    return 10;
}