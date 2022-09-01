%include "io.inc"

section .text
global CMAIN
CMAIN:
    GET_DEC 4, eax ;month
    GET_DEC 4, ebx ;day
    
    dec eax
    cdq
    mov ecx, 2
    idiv ecx
    
    mov ecx, 83
    imul eax, ecx
    
    mov ecx, 41
    imul edx, ecx
    
    add eax, edx
    add eax, ebx
    
    PRINT_DEC 4, eax
    
    xor eax, eax
    ret