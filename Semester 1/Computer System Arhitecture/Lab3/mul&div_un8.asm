bits 32 

global start

extern exit 
import exit msvcrt.dll  


segment data use32 class=data
;1/a+200*b-c/(d+1)+x/a-e unsigned rep
;a,b-word; c,d-byte; e-doubleword; x-qword
a dw 2
b dw 3
c db 6
d db 1
e dw 4
x dq 8
y resd 1; reserving a doubleword



segment code use32 class=code
start:
    ;1/a
    mov eax,0
    mov al,1
    mov ah,0 ;convert al->ax
    mov dx,0 ;convert ax->dx:ax because a is word so deimpartitul needs to be dword
    div word [a];catul in ax si restul in dx
    mov [y],eax
    ;+200*b
    mov eax,0
    mov ax,200
    mul word [b]; dx:ax=200*b
    push dx
    push ax
    pop eax;dx:ax->eax
    add [y],eax
    ;-c/(d+1)
    mov eax,0
    mov ebx,0
    mov bl,[d]
    add bl,1
    mov al,[c]
    mov ah,0;al->ax we need c to be word because d is byte
    div bl;al catul si ah restul
    mov ah,0 ;convert al->ax
    mov dx,0 ;convert ax->dx:ax
    push dx
    push ax
    pop eax;dx:ax->eax
    sub [y],eax
    ;+x/a-e
    mov eax,0
    mov edx,0
    mov ax,[a]
    mov dx,0;ax->dx:ax
    push dx
    push ax
    pop eax;dx:ax->eax
    mov ebx,eax
    mov eax,dword[x]
    mov edx, dword[x+4]
    div eax;eax catul si adx restul
    add [y],eax
    mov eax,[e]
    sub [y],eax
    
    push dword 0 
    call [exit]