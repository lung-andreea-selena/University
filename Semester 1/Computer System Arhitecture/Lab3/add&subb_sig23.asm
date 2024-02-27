bits 32 

global start

extern exit 
import exit msvcrt.dll  


segment data use32 class=data

;a + b + c + d - (a + b) - signed rep
;a - byte, b - word, c - double word, d - qword 

a db 2
b dw 1
c dd 3
d dq 5
x resq 1

segment code use32 class=code
start:
    
    ;(a+b)
    mov al,[a]
    cbw
    add ax,[b]
    mov bx, ax
    ;a+b+c+d
    mov al,[a]
    cbw
    add ax,[b]
    cwde
    add eax,[c]
    cdq
    add eax, dword[d]
    add edx, dword[d+4]
    mov dword [x], eax
    mov dword [x+4], edx
    ;a+b+c+d-(a+b)
    mov ax,bx
    cwde
    cdq
    sub dword[x],eax
    sbb dword[x+4],edx

    push dword 0 
    call [exit]