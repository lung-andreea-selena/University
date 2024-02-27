bits 32 

global start

extern exit 
import exit msvcrt.dll  


segment data use32 class=data

;((a + a) + (b + b) + (c + c)) - d 
;a - byte, b - word, c - double word, d - qword - Unsigned representation

a db 1
b dw 2
c dd 3
d dq 2
x resq 1
segment code use32 class=code
start:
    ;(a+a)+(b+b)+(c+c)
    mov eax,0
    mov al,[a]
    add al,[a]
    mov ebx,0
    mov bx, [b]
    add bx, [b]
    mov ecx,[c]
    add ecx,[c]
    add eax,ebx
    add eax, ecx
    ;((a+a)+(b+b)+(c+c))-d
    mov edx,0
    sub eax, dword [d]
    sbb edx, dword [d+4]
    mov dword [x],eax
    mov dword [x+4],edx
    

    push dword 0 
    call [exit]