bits 32 

global start        

extern exit, fopen, fclose, fread, printf
import exit msvcrt.dll
import fclose msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import printf msvcrt.dll   


segment data use32 class=data
    filename db "file.txt", 0
    read db "r", 0
    descriptor dd 0
    bytes_read dd 0
    highest_freq_char dd 0
    char_freq dd 0
    format db "%c: %d", 0
    buffer resb 2000
    
; 8. A text file is given. Read the content of the file, determine the uppercase letter
; with the highest frequency and display the letter along with its frequency on the screen. 
; The name of text file is defined in the data segment.
segment code use32 class=code
    start:
        ; opening the file
        push read
        push filename
        call [fopen]
        add esp, 4*2
        
        ;checking if the file has succesfully opened
        cmp eax, 0
        je final
        mov [descriptor], eax
        
        ;reading from the file
        reading:
            push dword [descriptor]
            push dword 100 ; we read 100 bytes at a time (number)
            push dword 1; 1=> byte (size)
            push dword buffer ; where we store what we read from the file, the adress from where we begin
            call [fread] ;in eax will be the number of bytes the function managed to read 
            add esp, 4*4
            add dword[bytes_read], eax
            cmp eax, 0  
            jne reading
            
        ;checking the most frequent uppercase letter
        mov esi, buffer ;the adress where the string begins
        mov ecx, [bytes_read] ; the length of the string
        looping:
            push ecx
            lodsb ; in al is going to be the first character from esi adress and then esi++
            cmp al, 'A'
            jb end_loop
            cmp al, 'Z'
            jg end_loop
            mov ebx, 0 ; in ebx we are going to count the frequency of the character
            mov edi, buffer
            mov ecx, [bytes_read]
            count:
                scasb ; compare al with the byte that it finds at the edi's adress, edi++
                jne dont_count
                add ebx, 1
                dont_count:
                loop count
            cmp dword [char_freq], ebx
            jg end_loop
            mov [highest_freq_char], al
            mov [char_freq], ebx
            end_loop:
            pop ecx
            loop looping ;ecx-- loop stops when ecx=0 => end of string
        
        ;print the most frequent uppercase letter, along with the number of occurrences
        push dword [char_freq]
        push dword [highest_freq_char]
        push dword format
        call [printf]
        add esp, 4*3
        
        final:
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
