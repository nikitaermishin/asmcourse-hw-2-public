%include "io.inc"

section .data
    card db 50, 51, 52, 53, 54, 55, 56, 57, 84, 74, 81, 75, 65
    suit db 83, 67, 68, 72

section .text
global CMAIN
CMAIN:
    GET_UDEC 4, eax
    sub eax, 1
    cdq
    mov ecx, 13
    div ecx
    
    mov ecx, card
    mov ecx, dword[ecx + edx]
    PRINT_CHAR ecx
    
    mov ecx, suit
    mov ecx, dword[ecx + eax]
    PRINT_CHAR ecx
    
    
    xor eax, eax
    ret