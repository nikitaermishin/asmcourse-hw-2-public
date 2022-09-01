%include "io.inc"

section .text
global CMAIN
CMAIN:
    mov eax, 0

    GET_UDEC 1, al
    GET_UDEC 1, ah
    GET_UDEC 1, dl
    GET_UDEC 1, dh
    
    shl edx, 16
    add edx, eax
    
    PRINT_UDEC 4, edx

    xor eax, eax
    ret