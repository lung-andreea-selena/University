bits 32

global show

extern printf
import printf msvcrt.dll

segment code use32 class=code public
    show:
    mov ecx, 126
    looping:
    mov eax, [esp+4] ; format
    push ecx
    ;printf(eax, ecx, ecx)
    push ecx
    push eax
    call [printf]
    add esp, 4*2
    pop ecx
    dec ecx
    cmp ecx, 31
    jne looping
    ret 4 ; returns to the main program, adding 4 to the esp (same process as doing: ret and add esp, 4)
    