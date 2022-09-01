%include "io.inc"

section .bss
    x resd 1
    y resd 1
    a11 resd 1
    a12 resd 1
    a21 resd 1
    a22 resd 1
    b1 resd 1
    b2 resd 1
    
    abs_cond_x resd 1
    abs_cond_y resd 1
    abs_x resd 1
    abs_y resd 1
    rel_x resd 1
    rel_y resd 1
    rel_y_base resd 1

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    GET_UDEC 4, [a11]
    GET_UDEC 4, [a12]
    GET_UDEC 4, [a21]
    GET_UDEC 4, [a22]
    GET_UDEC 4, [b1]
    GET_UDEC 4, [b2]
    
    ; calculate abs_cond_x
    ;-------------------------------
    ; 1) (b1 & a11 & (not a12)) | 
    ; 2) ((not b1) & a11 & (not a12)) | 
    ; 3) (b2 & a21 & (not a22)) | 
    ; 4) ((not b2) & a21 & (not a22))
    
    mov eax, dword[b1]
    mov ebx, dword[a11]
    mov ecx, dword[a12]
    
    ; 1)
    mov edx, eax
    and edx, ebx
    not ecx
    and edx, ecx
    mov esi, edx
    
    ; 2)
    not eax
    mov edx, eax
    and edx, ebx
    and edx, ecx
    or esi, edx
    
    mov eax, dword[b2]
    mov ebx, dword[a21]
    mov ecx, dword[a22]

    ; 3)    
    mov edx, eax
    and edx, ebx
    not ecx
    and edx, ecx
    or esi, edx
    
    ; 4)
    not eax
    mov edx, eax
    and edx, ebx
    and edx, ecx
    or esi, edx
    
    mov dword[abs_cond_x], esi
    
    ; calculate abs_cond_y
    ;-------------------------------
    ; 1) (b1 & (not a11) & a12) | 
    ; 2) ((not b1) & (not a11) & a12) | 
    ; 3) (b2 & (not a21) & a22) | 
    ; 4) ((not b2) & (not a21) & a22)
    
    mov eax, dword[b1]
    mov ebx, dword[a11]
    mov ecx, dword[a12]
    
    ; 1)
    mov edx, eax
    not ebx
    and edx, ebx
    and edx, ecx
    mov esi, edx
    
    ; 2)
    not eax
    mov edx, eax
    and edx, ebx
    and edx, ecx
    or esi, edx
    
    mov eax, dword[b2]
    mov ebx, dword[a21]
    mov ecx, dword[a22]
    
    ; 3)
    mov edx, eax
    not ebx
    and edx, ebx
    and edx, ecx
    or esi, edx
    
    ; 4)
    not eax
    mov edx, eax
    and edx, ebx
    and edx, ecx
    or esi, edx
    
    mov dword[abs_cond_y], esi
    
    ; calculate abs_x
    ;-------------------------------
    ; 1) (b1 & a11 & (not a12)) | 
    ; 2) (b2 & a21 & (not a22))
    
    mov eax, dword[b1]
    mov ebx, dword[a11]
    mov ecx, dword[a12]
    
    ; 1)
    mov edx, eax
    and edx, ebx
    not ecx
    and edx, ecx
    mov esi, edx
    
    mov eax, dword[b2]
    mov ebx, dword[a21]
    mov ecx, dword[a22]
    
    ; 2)
    mov edx, eax
    and edx, ebx
    not ecx
    and edx, ecx
    or esi, edx
    
    mov dword[abs_x], esi
    
    ; calculate abs_y
    ;-------------------------------
    ; 1) (b1 & (not a11) & a12) | 
    ; 2) (b2 & (not a21) & a22)
    
    mov eax, dword[b1]
    mov ebx, dword[a11]
    mov ecx, dword[a12]
    
    ; 1)
    mov edx, eax
    not ebx
    and edx, ebx
    and edx, ecx
    mov esi, edx
    
    mov eax, dword[b2]
    mov ebx, dword[a21]
    mov ecx, dword[a22]
    
    ; 2)
    mov edx, eax
    not ebx
    and edx, ebx
    and edx, ecx
    or esi, edx
    
    mov dword[abs_y], esi
    
    ; calculate rel_x
    ;-------------------------------
    ; 1) ((b1 & a11 & a12) & (not abs_y)) | 
    ; 2) (((not b1) & a11 & a12) & abs_y) | 
    ; 3) ((b2 & a21 & a22) & (not abs_y)) | 
    ; 4) (((not b2) & a21 & a22) & abs_y)
    
    mov eax, dword[b1]
    mov ebx, dword[a11]
    mov ecx, dword[a12]
    mov edi, dword[abs_y]
    
    ; 1)
    mov edx, eax
    and edx, ebx
    and edx, ecx
    not edi
    and edx, edi
    not edi
    mov esi, edx
    
    ; 2)
    not eax
    mov edx, eax
    and edx, ebx
    and edx, ecx
    and edx, edi
    or esi, edx
    
    mov eax, dword[b2]
    mov ebx, dword[a21]
    mov ecx, dword[a22]
    
    ; 3)
    mov edx, eax
    and edx, ebx
    and edx, ecx
    not edi
    and edx, edi
    not edi
    or esi, edx
    
    ; 4)
    not eax
    mov edx, eax
    and edx, ebx
    and edx, ecx
    and edx, edi
    or esi, edx
    
    mov dword[rel_x], esi
    
    ; calculate rel_y
    ;-------------------------------
    ; 1) ((b1 & a11 & a12) & (not abs_x)) | 
    ; 2) (((not b1) & a11 & a12) & abs_x) | 
    ; 3) ((b2 & a21 & a22) & (not abs_x)) | 
    ; 4) (((not b2) & a21 & a22) & abs_x)
    
    mov eax, dword[b1]
    mov ebx, dword[a11]
    mov ecx, dword[a12]
    mov edi, dword[abs_x]
    
    ; 1)
    mov edx, eax
    and edx, ebx
    and edx, ecx
    not edi
    and edx, edi
    not edi
    mov esi, edx
    
    ; 2)
    not eax
    mov edx, eax
    and edx, ebx
    and edx, ecx
    and edx, edi
    or esi, edx
    
    mov eax, dword[b2]
    mov ebx, dword[a21]
    mov ecx, dword[a22]
    
    ; 3)
    mov edx, eax
    and edx, ebx
    and edx, ecx
    not edi
    and edx, edi
    not edi
    or esi, edx
    
    ; 4)
    not eax
    mov edx, eax
    and edx, ebx
    and edx, ecx
    and edx, edi
    or esi, edx
    
    mov dword[rel_y], esi
    
    ; calculate rel_y_base
    ;-------------------------------
    ; 1) ((not b1) & a11 & a12) | 
    ; 2) ((not b2) & a21 & a22)
    
    mov eax, dword[b1]
    mov ebx, dword[a11]
    mov ecx, dword[a12]
    
    ; 1)
    not eax
    mov edx, eax
    and edx, ebx
    and edx, ecx
    mov esi, edx
    
    mov eax, dword[b2]
    mov ebx, dword[a21]
    mov ecx, dword[a22]
    
    ; 2)
    not eax
    mov edx, eax
    and edx, ebx
    and edx, ecx
    or esi, edx
    
    mov dword[rel_y_base], esi
    
    ; calculate x
    ;-------------------------------
    ; 1) (abs_cond_x & abs_x) | 
    ; 2) ((not abs_cond_x) & abs_cond_y & rel_x) | 
    ; 3) ((not abs_cond_x) & (not abs_cond_y))
    
    mov eax, dword[abs_cond_x]
    mov ebx, dword[abs_x]
    mov ecx, dword[abs_cond_y]
    mov edi, dword[rel_x]
    
    ; 1)
    mov edx, eax
    and edx, ebx
    mov esi, edx
    
    ; 2)
    not eax
    mov edx, eax
    and edx, ecx
    and edx, edi
    or esi, edx
    
    ; 3)
    mov edx, eax
    not ecx
    and edx, ecx
    or esi, edx
    
    mov dword[x], esi
    
    ; calculate y
    ;-------------------------------
    ; 1) (abs_cond_y & abs_y) | 
    ; 2) ((not abs_cond_y) & abs_cond_x & rel_y) | 
    ; 3) ((not abs_cond_y) & (not abs_cond_x) & rel_y_base)
    
    mov eax, dword[abs_cond_y]
    mov ebx, dword[abs_y]
    mov ecx, dword[abs_cond_x]
    mov edi, dword[rel_y]
    
    ; 1)
    mov edx, eax
    and edx, ebx
    mov esi, edx
    
    ; 2)
    not eax
    mov edx, eax
    and edx, ecx
    and edx, edi
    or esi, edx
    
    mov edi, dword[rel_y_base]
    
    ; 3)
    mov edx, eax
    not ecx
    and edx, ecx
    and edx, edi
    or esi, edx
    
    mov dword[y], esi
    
    ; display x and y
    ;-------------------------------
    
    PRINT_UDEC 4, x
    PRINT_CHAR " "
    PRINT_UDEC 4, y
    
    
    xor eax, eax
    ret