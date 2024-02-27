bits 32 

global start

extern exit 
import exit msvcrt.dll  


segment data use32 class=data

;(a+b+c)-(d+d)
a dw 4
b dw 3
c dw 7
d dw 2

segment code use32 class=code
start:
    
    
    mov eax,0
    mov ax,[a]
    add ax,[b]
    add ax,[c]
    mov ebx,0
    mov bx,[d]
    add bx,[d]
    sub ax,bx

    push dword 0 
    call [exit] 