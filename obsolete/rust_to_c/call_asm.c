// this is example of how to call ASM from C
// 

 // compile by: gcc call_asm.c asmlib.o

#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <inttypes.h>

// add 1 to the value passed by reference (pointer)
void asm_add_one_by_ref(int64_t* i);

// add 1 to the value passed by value
int64_t asm_add_one_by_val(int64_t i);

// add 2 numbers and return the result: use pointers
int64_t asm_add_return(int64_t* a, int64_t* b);
void asm_add_void(int64_t* a, int64_t* b, int64_t* result);

// strlen() copycat
int64_t asm_strlen(char *s);

// strcmp() copycat
int64_t asm_strcmp(char *s1, char *s2);

// memset copycat
void asm_memset(char *s, char c, size_t n);

// sum of integer arrays
int64_t asm_sum(int64_t *tab, int64_t n);

char *ss = "0123456789";

// thi
int main() {
    // pass one argument: an integer pointer and add one
    int64_t i = 10;
    asm_add_one_by_ref(&i);
    assert(i == 11);

    assert(asm_add_one_by_val(10) == 11);

    // pass a string
    char *s = "0123456789";
    assert(asm_strlen(s) == 10);

    // add 2 numbers and get result
    int64_t a = 10, b = 10;
    assert(asm_add_return(&a, &b) == 20);

    // add 2 numbers and store result into 3rd parameter
    int64_t result;
    asm_add_void(&a, &b, &result);
    assert(result == 20);

    // compare strings
    //printf("%ld\n", strcmp("Hello", "Hello1"));
    //assert(asm_strcmp("Hello world1", "Hello") == 1);

    // memset
    char digits[] = "0123456789";
    asm_memset(digits, '1', strlen(digits));
    assert(strcmp(digits, "1111111111") == 0);

    // integer array
    int64_t numbers[] = {10,100,1000,10000};
    assert(asm_sum(numbers, 4) == 11110);
 
    return 0;
}

//    printf("%ld %ld %ld\n", a, b, result);