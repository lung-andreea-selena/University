bits 32 

global start

extern exit 
import exit msvcrt.dll  


segment data use32 class=data

;(a-c)+(b+b+d)
a db 8
c db 3
b db 2
d db 5

segment code use32 class=code
start:
    
   
    mov al,[a]
    sub al,[c]
    mov bl,[b]
    add bl,[b]
    add bl,[d]
    add al,bl
    
    push dword 0 
    call [exit] 