; -----------------------------------------------------------------------------
; compile by: nasm -felf64 asmlib.asm
; -----------------------------------------------------------------------------
        global  asm_strlen, nb_words
        section .text

;------------------------------------------------------------------------------------
; simulate strlen() C function
;   rdi: message address
;   length returned in RAX
;------------------------------------------------------------------------------------
asm_strlen:
            xor rax, rax                ; set length to 0
strlen.begin:            
            cmp byte [rdi+rax], 0       ; if we reached NULL byte, stops 
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
            cmp byte [rdi+rbx], 0       ; if we reached NULL byte, stops 
            jz nb_words.end
            cmp byte [rdi+rbx], 0x20    ; do we reached a space byte ?
            jz nb_words.new_space
            jmp nb_words.no_new_space
nb_words.new_space:
            inc rax                     ; add 1 to nb_words
nb_words.no_new_space:
            inc rbx                     ; move to the next byte
            jmp nb_words.begin
nb_words.end:
            inc rax                     ; we missed the last word
            ret
