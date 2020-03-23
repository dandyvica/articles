call_asm:	call_asm.o asmlib.o
	gcc -g call_asm.c asmlib.o -o call_asm

asmlib.o: asmlib.asm
	nasm -felf64 asmlib.asm

clean: 
	rm *.o call_asm a.out