// simple malloc/free calls
// compile with gcc -g c_strlen.c -o c_strlen

#include <stdio.h>
#include <stdlib.h>

int main() {
    // alloc some memory
    char *alpha = "abcdefghijklmnopqrstuvwxyz";

    // suppose to free previously allocated memory
    // int l = string_length(alpha);
    // printf("%d\n",l);

    char *s = malloc(1000);

    free(s);

    return 0;
}