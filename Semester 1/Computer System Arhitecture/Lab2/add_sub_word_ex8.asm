bits 32 

global start

extern exit 
import exit msvcrt.dll  


segment data use32 class=data

;(b+c+d)-(a+a)
a dw 5
b dw 6
c dw 8
d dw 2

segment code use32 class=code
start:
    
    mov eax,0
    mov ax,[b]
    add ax,[c]
    add ax,[d]
    mov ebx,0
    mov bx,[a]
    add bx,[a]
    sub ax,bx

    push dword 0 
    call [exit] 