bits 32 

global start

extern exit 
import exit msvcrt.dll  

;2*(a+b)-e
;a,b,c,d-byte, e,f,g,h-word

segment data use32 class=data
    a db 23
    b db 8
    e dw 40

segment code use32 class=code
    start:
        mov EAX,0
        mov AH,[a]
        add AH,[b]  ; AH = a + b
        mov AL,2
        mul AH   ; AX = AL * AH = 2 * (a + b)
        sub AX,[e]  ; AX = 2 * (a + b) - e
    
    
    

    push dword 0 
    call [exit] 