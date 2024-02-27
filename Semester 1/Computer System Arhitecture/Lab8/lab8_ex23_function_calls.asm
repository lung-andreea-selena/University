bits 32
global start

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    format db "%x", 0
    n dd 0
    message db "n= ", 0
    message2 db "The unsigned representation of the number in base 10 is: %d", 10,  0
    message3 db "The signed representation of the number in base 10 is: %d", 0
    
    
; 23. Read a hexadecimal number with 2 digits from the keyboard. 
; Display the number in base 10, in both interpretations: as an unsigned number and as an signed number (on 8 bits).
segment code use32 class=code
    start:
        ;reading the number
        push dword message  
		call [printf]      
		add esp, 4 * 1    
        push dword n
		push dword format
		call [scanf]       
		add esp, 4 * 2  
        
        ;unsigned print
        push dword [n]
        push dword message2
        call [printf]
        add esp, 4*2
        
        ;signed print
        mov eax, [n]
        cmp al, 0 
        jns print ;verifies sign flag
        sub eax, 256 ; if sign flag=1 => get 2's complement from subtracting from eax, 256
        
        print:
        push dword eax
        push dword message3
        call [printf]
        add esp, 4*2
        
        push dword 0        ; push the parameter for exit onto the stack
        call [exit]         ; call exit to terminate the program
