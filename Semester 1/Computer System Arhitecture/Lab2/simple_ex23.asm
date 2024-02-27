bits 32 

global start

extern exit 
import exit msvcrt.dll  


segment data use32 class=data

;256*1
a dw 256
b dw 1

segment code use32 class=code
start:
    
    mov ax,[a]
    mov bx,[b]
    mul bx

    push dword 0 
    call [exit]