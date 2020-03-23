; -----------------------------------------------------------------------------
; compile by: nasm -felf64 asm_wc.asm
; -----------------------------------------------------------------------------
        global  wc
        section .text

;------------------------------------------------------------------------------------
; simulate strlen() C function
;   rdi: message address
;   length returned in RAX
;------------------------------------------------------------------------------------
wc:
            xor rax, rax                ; set length to 0
wc.begin:            
            cmp byte [rdi+rax], 0       ; if we reached NULL byte, stops 
            jz wc.end
            inc rax                     ; otherwise add 1 to length
            jmp wc.begin
wc.end:
            ret                         ; RAX is string length

