// simple malloc/free calls
// compile with gcc -g c_strlen.c -o c_strlen

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern size_t how_many_characters(const char *str);

int main() {
    // alloc some memory
    char *alpha = "abcdefghijklmnopqrstuvwxyz";
    printf("Length of %s is %lu\n", alpha, how_many_characters(alpha));    

    // suppose to free previously allocated memory
    //printf("Length of %s is %lu\n", alpha, strlen(alpha));

    return 0;
}
