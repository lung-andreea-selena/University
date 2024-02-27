;Given the byte A and the word B, compute the doubleword C as follows:
;the bits 24-31 of C are the same as the bits of A
;the bits 16-23 of C are the invert of the bits of the lowest byte of B
;the bits 10-15 of C have the value 1
;the bits 2-9 of C are the same as the bits of the highest byte of B
;the bits 0-1 both contain the value of the sign bit of A

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 10011000b
    b dw 1001011001010100b
    c resd 1

; our code starts here
segment code use32 class=code
    start:
    ;the bits 24-31 of C are the same as the bits of A
    mov eax,0
    mov al,[a]
    mov cl,8
    shl eax,cl;ah is ocupied with A's bits
    ;the bits 16-23 of C are the invert of the bits of the lowest byte of B
    mov bx,[b]
    not bx
    or al,bl;in al are the invert 0-7 bits of B
    mov cl,16
    shl eax,cl;first 16 bits of eax are ocupied
    ;the bits 10-15 of C have the value 1
    or ax, 1111110000000000b;first 22 are ocupied
    ;the bits 2-9 of C are the same as the bits of the highest byte of B
    mov dx,0
    mov bx,[b]
    or dl,bh
    mov cl,2
    shl dx,cl;first bits 2-9 of dx are ocupied
    ;the bits 0-1 both contain the value of the sign bit of A
    mov bl,[a]
    mov cl,1
    sar bl,cl;bits 6-7 of bl we have sign bit of A
    mov cl,2
    rol bl,cl;first 2 bits of bl are sign bit of A
    and bl, 00000011b
    or dl,bl;in dx we have what we need
    or ax,dx
    mov [c],eax
    
    push    dword 0      ; push the parameter for exit onto the stack
    call    [exit]       ; call exit to terminate the program
