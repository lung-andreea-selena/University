bits 32
global start

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    format db "%d", 0
    a dd 100
    b dd 0
    message1 db "b= ", 0
    message2 db "a+a/b= %d", 0
    
    
; A natural number a (a: dword, defined in the data segment) is given.
; Read a natural number b from the keyboard and calculate: a + a/b. 
;Display the result of this operation. The values will be displayed in decimal format (base 10) with sign.
segment code use32 class=code
    start:
        ;reading from console b
        push dword message1  ; push b on the stack
		call [printf]       ; calling the function
		add esp, 4 * 1     ; clearing the stack
        push dword b       ; pushing the parameters on the stack
		push dword format
		call [scanf]       ; calling the function
		add esp, 4 * 2     ; clearing the stack
        
        ; a + a/b
        mov eax, [a]
        cdq
        idiv dword [b]
        add [a], eax
        
        ;printf (message2, a)
        push dword [a] ; [] to print the value but if we had a string of char. it shouldn't be with []
        push dword message2
        call [printf]
        add esp, 4*2
        
        push dword 0        ; push the parameter for exit onto the stack
        call [exit]         ; call exit to terminate the program
