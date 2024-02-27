bits 32 

global start

extern exit 
import exit msvcrt.dll  


segment data use32 class=data

;(b+c+d)-(a+a) - signed rep
;a - byte, b - word, c - double word, d - qword 

a db 2
b dw 4
c dd 5
d dq 3
x resq 1
segment code use32 class=code
start:
    ;(b+c+d)
    mov ax,[b]
    cwde ;because c is doubleword
    add eax,[c]
    cdq ;because d is qword
    add eax,dword [d]
    adc edx, dword [d+4]
    mov dword[x], eax
    mov dword [x+4], edx
    ;(a+a)
    mov al,[a]
    add al,[a]
    cbw
    cwde
    cdq
    sub dword [x],eax
    sbb dword [x+4], edx
    
    

    push dword 0 
    call [exit]