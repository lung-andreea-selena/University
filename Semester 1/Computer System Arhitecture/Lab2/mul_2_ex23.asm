bits 32 

global start

extern exit 
import exit msvcrt.dll  

;[(a+b)*2]/(a+d)
;a,b,c,d-byte, e,f,g,h-word

segment data use32 class=data
    a db 6
    b db 5
    d db 8

segment code use32 class=code
    start:
        mov EAX,0
        mov AL,[a]
        add AL,[b]
        mov AH,2
        mul AH  ; AX = AH * AL = 2 * (a + b)
        mov EBX,0
        mov BL,[a]
        add BL,[d] ; BL = a + d
        div BL   ; AH = AX % BL & AL = AX / BL 
        
        
        
    push dword 0 
    call [exit] 