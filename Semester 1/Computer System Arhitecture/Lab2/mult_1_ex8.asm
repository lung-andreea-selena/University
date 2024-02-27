bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions


;(100*a+d+5-75*b)/(c-5)
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
        mov AL,100 ;AL = 100
        mov AH,[a]  ;AH = a
        mul AH  ; AX = AH * AL = 100 * a
        add AX,5 ; AX = 100 * a + 5
        add AX,[d] ; AX = 100 * a + 5 + d
        mov BX,AX ; BX = AX = 100 * a + 5 + d
        mov EAX,0
        mov AH,75
        mov AL,[b]
        mul AH ; AX = AH * AL = 75 * b
        sub BX,AX  ; BX = 100 * a + 5 + d - 75 * b
        mov AX,0 
        mov AX,BX  ; AX = BX => AX = 100 * a + 5 + d - 75 * b
        mov BX,0
        mov BL,[c]
        sub BL,5
        div BL   ; AL = AX / BL & AH = AX % BL
        mov BX,[d]
        div bx
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
