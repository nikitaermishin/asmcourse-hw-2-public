%include "io.inc"

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    mov eax, 0
    mov ecx, 0
    GET_CHAR al
    GET_DEC 1, cl
    
    GET_CHAR ah ; space :)
    
    GET_CHAR ah
    GET_DEC 1, ch
    
    sub al, ah
    sub cl, ch
    cbw
    or ah, 1
    imul ah
    mov dx, ax
      
    mov al, cl
    cbw
    or ah, 1
    imul ah
    
    add dx, ax
    PRINT_DEC 1, dx
            
    xor eax, eax
    ret