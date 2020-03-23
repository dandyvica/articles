; -----------------------------------------------------------------------------
; compile by: nasm -felf64 asmlib.asm
; -----------------------------------------------------------------------------

global  asm_add_one_by_ref, asm_add_one_by_val
global  asm_add_return, asm_add_void
global  asm_strlen, asm_strcmp
global  asm_memset
global  asm_sum


section .text

;------------------------------------------------------------------------------------
; add one to the parameter pointer passed
;------------------------------------------------------------------------------------
asm_add_one_by_ref:
            ; function prologue
            push rbp 
            mov  rbp, rsp

            inc dword [rdi]             ; increment the value pointed by RDI

            ; function epilogue
            leave
            ret 

;------------------------------------------------------------------------------------
; add one to the integer passed
;------------------------------------------------------------------------------------
asm_add_one_by_val:
            mov rax, rdi
            inc rax
            ret 


;------------------------------------------------------------------------------------
; add 2 numbers (pointers passed) and return value
;------------------------------------------------------------------------------------
asm_add_return:
            mov rax, [rdi]              ; save the value pointed by RDI into RAX
            add rax, [rsi]              ; add the value pointed by RSI
            ret                         ; RAX containes addition of 2 numbers

;------------------------------------------------------------------------------------
; add 2 numbers (pointers passed) and save into thrid paramter (RDX)
; use RAX as a temp variable
;------------------------------------------------------------------------------------
asm_add_void:
            mov rax, [rdi]              ; save the value pointed by RDI into RAX
            add rax, [rsi]              ; add the value pointed by RSI
            mov [rdx], rax              ; save result into the value pointed by 3rd paramter (RDX)
            ret                         ; RAX containes addition of 2 numbers

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
; simulate strcmp() C function
;   rdi: first string address
;   rsi: second string address
;   length returned in RAX
;------------------------------------------------------------------------------------
asm_strcmp:
            xor rax, rax                ; set return code to 0
            xor rbx, rbx                ; set counter to 0
strcmp.begin:  
            ; end of strings?
            cmp byte [rdi+rbx], 0       ; end of first string?
            jz strcmp.end
            cmp byte [rsi+rbx], 0       ; end of second string?
            jz strcmp.end

            ; now compare strings
            mov cl, byte [rdi+rbx]     ; copy byte from first string        
            cmp cl, byte [rsi+rbx]     ; compare it to second string
            jne strcmp.diff             ; bytes are different: we can leave
            inc rbx                     ; otherwise add 1 to counter
            jmp strcmp.begin
strcmp.diff:
            mov rax, 1                  ; strings are different: return 1
strcmp.end:
            ret                         ; RAX is the return code

;------------------------------------------------------------------------------------
; simulate memset() C function
;   rdi: first address
;   rsi: byte to set
;   rdx: length to set
;------------------------------------------------------------------------------------
asm_memset:
            xor rcx, rcx                ; set counter to 0
asm_memset_begin:
            cmp rcx, rdx                ; counter == length ?
            jge  asm_memset_end         ; if counter >= nb_bytes then end
            mov byte [rdi+rcx], sil     ; set memory to 0
            inc rcx                     ; rcx -= 1
            jmp asm_memset_begin
asm_memset_end:   
            ret      

;------------------------------------------------------------------------------------
; calculate summation of DQWORDS passed as an array 
;   rdi: array address
;   rsi: number of elements
;   rax: return value
;------------------------------------------------------------------------------------
asm_sum:
            xor rcx, rcx                ; set counter to 0
            xor rax, rax                ; set sum to 0
asm_sum_begin:
            cmp rcx, rsi                ; counter == number of elements ?
            jge  asm_sum_end         ; if counter > nb_bytes then end
            add rax, [rdi+8*rcx]
            inc rcx                     ; rcx -= 1
            jmp asm_sum_begin
asm_sum_end:   
            ret      




