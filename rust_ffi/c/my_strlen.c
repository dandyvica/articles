// compile with: gcc my_strlen.c -shared -fPIC -o libmy_strlen.so
#include <stdio.h>

size_t strlen(const char *s)
{
    printf("strlen() called\n");
    return 0;
}
