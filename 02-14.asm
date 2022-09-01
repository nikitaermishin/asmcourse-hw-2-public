%include "io.inc"

section .text
global CMAIN
CMAIN:
    GET_UDEC 2, ax ;N - rect dimension 1
    GET_UDEC 2, dx ;M - rect dimension 2
    
    mul dx 
    
    ; dx:ax -> eax
    mov cx, ax
    mov eax, 0
    mov ax, dx
    shl eax, 16
    add ax, cx
    
    GET_UDEC 4, edx ;K - boxes per sq. m.
    mul edx ;edx:eax -> eax
    
    GET_UDEC 4, ecx ;D - count per box
    div ecx ;q = eax, r = edx
    ;multiplying remainder (edx) by -1, moving left by 31 biy, adding to eax
    imul edx, -1
    shr edx, 31
    add eax, edx ; total box count
    mov ecx, eax
    
    mov edx, 60
    GET_UDEC 4, eax
    mul edx
    GET_UDEC 4, edx
    add eax, edx ; daytime in minutes
    
    sub eax, 360; -6 hours
    not eax
    shr eax, 31 ; eax = (daytime >= 5:59 ? 1 : 0)
    mul ecx
    
    mov edx, 0
    mov ebx, 3
    idiv ebx
    imul edx, -1
    shr edx, 31
    add eax, edx
    sub ecx, eax
    
    PRINT_UDEC 4, ecx


    xor eax, eax
    ret