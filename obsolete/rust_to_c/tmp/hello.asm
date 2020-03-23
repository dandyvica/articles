; ----------------------------------------------------------------------------------------
; Writes "Hello, World" to the console using only system calls. Runs on 64-bit Linux only.
; To assemble and run:
;
;     nasm -felf64 hello.asm && ld hello.o && ./a.out
; ----------------------------------------------------------------------------------------

            global    _start

            section   .data
message:    db        "Hello, World", 10, 0      ; note the newline at the end

;------------------------------------------------------------------------------------
; exit process
;   rdi: exit code to return to OS
;------------------------------------------------------------------------------------
exit:       mov rax, 60
            syscall
            ret

;------------------------------------------------------------------------------------
; write(1, addr message, len)
;   rdi contains message address
;   rdx = message length 
;------------------------------------------------------------------------------------
write_stdout:      
            mov rax, 1                   ; system call for write
            mov rdi, 1                   ; file handle 1 is stdout 
            syscall
            ret

;------------------------------------------------------------------------------------
; simulate strlen() C function
;   rsi: message address
;   length returned in RAX
;------------------------------------------------------------------------------------
strlen:
            xor rax, rax                ; set length to 0
strlen.begin:            
            cmp byte [rsi+rax], 0       ; if we reached NULL byte, stops 
            jz strlen.end
            inc rax                     ; otherwise add 1 to length
            jmp strlen.begin
strlen.end:
            ret                         ; RAX is string length

;------------------------------------------------------------------------------------
; return in RAX the number of words from the input string passed in RSI
;   rsi: string address
;   #words returned in RAX
;------------------------------------------------------------------------------------
nb_words:
            xor rax, rax                ; set nb_words to 0
            xor rbx, rbx                ; set length to 0
nb_words.begin:            
            cmp byte [rsi+rbx], 0       ; if we reached NULL byte, stops 
            jz nb_words.end
            cmp byte [rsi+rbx], 0x20    ; do we reached a space byte ?
            jz nb_words.new_space
            jmp nb_words.no_new_space
nb_words.new_space:
            inc rax                     ; add 1 to nb_words
nb_words.no_new_space:
            inc rbx                     ; move to the next byte
            jmp nb_words.begin
nb_words.end:
            ret

;------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------
            ; start of code section
            ; start of code section
            section   .text

_start:
            mov rsi, message              ; address of string to output

            ; calculate string length
            call strlen
            mov rdx, rax

            ; write string to STDOUT
            call write_stdout             ; invoke operating system to do the write

            ; calculate number of words
            call nb_words

            ; write string to STDOUT
            call write_stdout             ; invoke operating system to do the write

            ; exit process with return code 0
            xor rdi, rdi                  ; exit code 0
            call exit

