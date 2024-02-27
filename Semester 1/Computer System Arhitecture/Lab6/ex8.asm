bits 32
global start

extern exit
import exit msvcrt.dll

segment data use32 class=data
    s dd 12345678h, 1A2C3C4Dh, 98FCDC76h
    len equ ($-s)/4;because we work with each doubleword
    d times len db 0;we need only a byte from each doubleword
    
;8. A list of doublewords is given. Obtain the list made out of the low bytes of the high words 
;of each doubleword from the given list with the property that these bytes are palindromes in base 10

segment code use32 class=code
    start:
    mov ecx, len
    mov esi, s
    mov edi, d
    cld ;we work from left to right 
    jecxz final ;jump if ecx =0
    while_1:
        lodsw   ;first we take 5678 (for first case) and move to ax but then ignore it
        lodsw   ; ax = high word
        mov ah, 0 ; in ax we be left only the low bytes from the word
        mov dh, al  ; dh - copy of al in al are the low bytes from word
        mov bl, 100d
        div bl  ; al = cifra sutelor, ah = restul(cifra zecilor si cifra unitatilor)
        mov dl, al  ; dl - cifra sutelor
        mov al, ah
        mov ah, 0; in ax will be cifra zecilor si cifra unitatilor
        mov bl, 10d
        div bl  ; al = cifra zecilor, ah = cifra unitatilor
        cmp dl, 0 ; compare if the number in base 10 has 3 digits, if dl=0 then we have only 2 digits or less
        je two_digits ;jump if equal to two_digits
        cmp dl, ah ;compare cifra sutelor with cifra unitatilor
        jne next ;if they are not equal=> go to the next number
        je copy ;if they are equal=> palindrome=> copy in d
        two_digits: ;in case it has two digits
            cmp al, 0; if al=0=> it has only 1 digit => palindrome
            je copy ;copy in d if al=0
            cmp al, ah ;if al!=0 compare cifra zecilor cu cifra unitatilor
            jne next ; if they are not equal=> !=palindrome=>next
        copy:
        mov al, dh ;we move the copy back in al because is palindrome
        stosb ; = mov [edi],al and inc edi; in edi puts al
        next:
        loop while_1
        
    
    final:
    push dword 0
    call [exit]