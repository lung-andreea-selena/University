bits 32 

global start

extern exit 
import exit msvcrt.dll  


segment data use32 class=data

;128+127
a dw 128
b dw 127

segment code use32 class=code
start:
    
    mov ax,[a]
    add ax,[b]

    push dword 0 
    call [exit] 