;Given the words A and B, compute the byte C as follows:
;the bits 0-5 are the same as the bits 5-10 of A
;the bits 6-7 are the same as the bits 1-2 of B.
;Compute the doubleword D as follows:
;the bits 8-15 are the same as the bits of C
;the bits 0-7 are the same as the bits 8-15 of B
;the bits 24-31 are the same as the bits 0-7 of A
;the bits 16-23 are the same as the bits 8-15 of A.

bits 32 
; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    
    a dw 1001110011010110b
    b dw 1010111000110101b
    c resb 1
    d resd 1

; our code starts here
segment code use32 class=code
    start:
    ;the bits 0-5 are the same as the bits 5-10 of A
    mov ax,[a]
    and ax, 0000011111100000b
    mov cl,5
    shr ax,cl;in al we have first 6 bits same as 5-10 A => c=00111111 (1 ocupied bits)
    or [c],al; c=00111111
    ;the bits 6-7 are the same as the bits 1-2 of B.
    mov ax,[b]
    and ax,0000000000000110b
    mov cl,5
    shl ax,cl; => c=11111111
    or [c],al
    ;Compute the doubleword D as follows:
    ;the bits 24-31 are the same as the bits 0-7 of A
    mov eax,0
    mov ax,[a]
    and ax,0000000011111111b
    mov cl,8
    shl eax,cl;the bits of A are on ax and then we work al and then shift all to the left and so on
    ;the bits 16-23 are the same as the bits 8-15 of A
    mov bx,[a]
    and bx,1111111100000000b
    mov cl,8
    shr bx,cl;=>0000000011111111
    or ax,bx;=> 1111111111111111
    mov cl,8
    shl eax,cl; first 16 bits are ocupied and the last 16 are empty
    ;the bits 8-15 are the same as the bits of C
    mov bl,[c]
    or al,bl;because we work with all the bits of c and we don't need a mask
    mov cl,8
    shl eax,cl; fist 24 bits are ocupied in eax
    ;the bits 0-7 are the same as the bits 8-15 of B
    mov bx,[b]
    and bx,1111111100000000b
    mov cl,8
    shr bx,cl
    or ax,bx;in eax is d
    mov [d],eax
    
    
    
    
    
    push    dword 0      ; push the parameter for exit onto the stack
    call    [exit]       ; call exit to terminate the program
