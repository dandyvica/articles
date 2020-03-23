/*
 * A small program that illustrates how to call the maxofthree function we wrote in
 * assembly language.
 */

 // compile by: gcc wc.c asm_wc.o

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

int64_t wc(char* s);

int main(int argc, char *argv[]) {

    // file handle
    FILE *fh;

    // open file for reading
    if ((fh = fopen(argv[1], "r")) == NULL) {
        fprintf(stderr, "Unable to open file <%s>", argv[1]);
        return 1;
    }    

    char line[256];

    while(fgets(line, 256, fh)) {
        printf("%ld\n", wc(line));
    }

    fclose(fh);    
    return 0;
}