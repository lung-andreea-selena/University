bits 32

global start

extern exit, fopen, fclose, fprintf
import exit msvcrt.dll
import fclose msvcrt.dll
import fopen msvcrt.dll
import fprintf msvcrt.dll

segment data use32 class=data
    filename db "file23.txt", 0
    write db "a", 0 ;append
    descriptor dd 0
    n dw 0feh
    format db "%x", 10, 0
    
; 23. A file name and a hexadecimal number (on 16 bits) are given.
; Create a file with the given name and write each nibble composing the hexadecimal number on a different line to file.
segment code use32 class=code
    start:
        ;opening the file
        push write
        push filename
        call [fopen]
        add esp, 4*2
        
        ;checking if the file has succesfully opened
        cmp eax, 0
        je final
        mov [descriptor], eax
        mov eax, 0
        mov ax, [n]
        
        ;dividing the number by 16 and writing each digit on a different line in the file
        looping:
            mov dl, 16
            div dl
            mov ebx, 0
            mov bl, ah
            push edx
            push eax
            
            ;writing in the file
            push ebx
            push dword format
            push dword [descriptor]
            call [fprintf]
            add esp, 4*3
            
            ;checking if we have any digits left
            pop eax
            pop edx
            cmp al, 0
            je out_of_loop
            mov ah, 0
            jmp looping
            
        out_of_loop:
    
    final:
    push dword 0
    call [exit]