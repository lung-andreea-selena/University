bits 32 

global start

extern exit 
import exit msvcrt.dll  


segment data use32 class=data
;(a*b-2*c*d)/(c-e)+x/a - signed rep
; a,b,c,d-byte; e-word; x-qword

a db 4
b db 5
c db 3
d db 2
e dw 1
x dq 12
y resd 1;reserving a doubleword


segment code use32 class=code
start:
    ;(a*b-2*c*d)
    mov eax,0
    mov al,[a]
    mul byte[b];ax=a*b
    mov dx,0;ax->dx:ax
    push dx
    push ax
    pop eax
    mov[y],eax
    ;
    mov eax,0
    mov al,[c]
    mul byte[d];ax=c*d
    mov ebx,0
    mov bx,2
    mul bx;dx:ax=2*c*d
    push dx
    push ax
    pop eax
    sub[y],eax
    ;(c-e)
    mov eax,0
    mov al,[c]
    mov ah,0;al->ax
    sub ax,[e]
    ;(a*b-2*c*d)/(c-e)
    mov ebx,0
    mov bx,ax
    mov eax,[y]
    div bx;ax catul, dx restul
    mov dx,0;ax->dx:ax
    push dx
    push ax
    pop eax
    mov[y],eax
    ;+x/a
    mov eax,0
    mov al,[a]
    mov ah,0;al->ax
    mov dx,0;ax->dx:ax
    push dx
    push ax
    pop eax
    mov ebx,eax
    mov eax,dword[x]
    mov edx,dword[x+4]
    div ebx;eax catul
    add[y],eax
    
    push dword 0 
    call [exit]