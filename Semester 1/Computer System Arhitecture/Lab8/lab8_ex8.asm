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
    mesaj db "b= ", 0
    mesaj2 db "a+a/b= %d", 0
    
    
; 8. Se da un numar natural a (dword, definit in segmentul de date).
; Sa se citeasca un numar natural b si sa se calculeze a + a/b. Sa se afiseze rez operatiei.
; (af in baza 10, cu semn)
segment code use32 class=code
    start:
        ;citim nr
        push dword mesaj  ; punem parametrul pe stiva
		call [printf]       ; apelam functia printf
		add esp, 4 * 1     ; eliberam parametrii de pe stiva
        push dword b       ; punem parametrii pe stiva de la dreapta la stanga
		push dword format
		call [scanf]       ; apelam functia scanf pentru citire
		add esp, 4 * 2     ; eliberam parametrii de pe stiva
        
        ; a + a/b
        mov eax, [a]
        cdq
        idiv dword [b]
        add [a], eax
        
        ;printf (mesaj, a)
        push dword [a]
        push dword mesaj2
        call [printf]
        add esp, 4*2
        
        push dword 0        ; push the parameter for exit onto the stack
        call [exit]         ; call exit to terminate the program
