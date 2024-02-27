bits 32 

global start

extern exit 
import exit msvcrt.dll  


segment data use32 class=data

;(a+b-d)+(a-b-d)
;a - byte, b - word, c - double word, d - qword 
a db 5
b dw 1
d dq 3
x resq 1 ;reserving 1 quadword

segment code use32 class=code
start:
    ;(a+b-d)
    mov eax, 0
    mov al,[a]
    add ax,[b] ;addinng in ax because b is a word
    mov edx,0
    sub eax, dword [d]; scad treptat pe d
    sbb edx, dword [d+4];sbb because there is a possibility to have a cf
    mov dword [x], eax
    mov dword [x+4], edx ;i put (a+b-d) in x
    ;(a-b-d)
    mov eax, 0
    mov al,[a]
    sub ax,[b]
    mov edx,0
    sub eax, dword [d]
    sbb edx, dword [d+4]
    ;(a+b-d)+(a-b-d)
    add dword [x], eax
    adc dword [x+4], edx

    push dword 0 
    call [exit] 