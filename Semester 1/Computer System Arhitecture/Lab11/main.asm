bits 32 

global start        

extern exit
extern show
import exit msvcrt.dll 


segment data use32 class=data public
    format db "Base 8: %o | ASCII: %c", 10, 0
    
    
; 8. Show for each number from 32 to 126 the value of the number (in base 8) and the character with that ASCII code.
segment code use32 class=code public
    start:
        push dword format
        call show
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
