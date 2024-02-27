bits 32 

global start

extern exit 
import exit msvcrt.dll  


segment data use32 class=data

;1/a+200*b-c/(d+1)+x/a-e signed rep
;a,b-word; c,d-byte; e-doubleword; x-qword

a dw 2
b dw 3
c db 6
d db 1
e dw 4
x dq 8
y resd 1;reserving a doubleword

segment code use32 class=code
start:
    
    mov ax,1
    cwd ; DX:AX=1
    idiv word [a] ;catul in ax si restul in dx
    cwde
    mov [y],eax
    mov ax,200
    imul word[b];is on dx:ax
    push dx
    push ax
    pop eax ; dx:ax->eax
    add [y],eax
    ;c/(d+1)
    mov al,[c]
    cbw
    mov bl,[d]
    add bl,1
    idiv bl;al catul si ah restul
    cbw
    cwde
    sub [y],eax
    ;x/a
    mov ax,[a]
    cwde
    mov ebx,eax
    mov eax,dword [x]
    mov edx, dword [x+4]
    idiv ebx;eax catul si edx restul
    add [y],eax
    mov eax,[e]
    sub [y],eax
    
    
    
    

    push dword 0 
    call [exit]