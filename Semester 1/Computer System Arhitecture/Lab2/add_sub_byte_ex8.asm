bits 32 

global start

extern exit 
import exit msvcrt.dll  


segment data use32 class=data

;(a+b-d)+(a-b-d)
a db 5
b db 1
d db 3

segment code use32 class=code
start:
    
    mov al,[a]
    add al,[b]
    sub al,[d]
    mov bl,[a]
    sub bl,[b]
    sub bl,[d]
    add al,bl

    push dword 0 
    call [exit] 