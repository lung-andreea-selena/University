bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)

;[(a+b)*3-c*2]+d
;a,b,c byte, d word

segment data use32 class=data
    ; ...
    a db 5
    b db 4
    c db 45
    d dw 40

; our code starts here
segment code use32 class=code
    start:
        mov EAX,0
        mov AL,[a]
        add AL,[b] ; AL = a + b
        mov AH,3
        mul AH    ; AX = AL * AH = (a + b) * 3
        mov EBX,0
        mov BX,AX
        mov EAX,0
        mov AL,2
        mul byte [c]  ; AX = AL * c = c * 2
        sub BX,AX
        add BX,[d]  ; BX = [(a+b)*3-c*2]+d
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
