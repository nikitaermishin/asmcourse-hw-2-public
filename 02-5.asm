%include "io.inc"

section .text
global CMAIN
CMAIN:
    
    GET_UDEC 4, eax
    GET_UDEC 1, cl
    
    ror eax, cl
    
    PRINT_UDEC 4, eax 
    
    xor eax, eax
    ret