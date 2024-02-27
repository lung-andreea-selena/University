bits 32

global _show

extern _printf

segment data use32 class=data public
    format db "Base 8: %o | ASCII: %c", 10, 0

segment code use32 class=code public
    _show:
    pop ebp
    mov ebp, esp
    mov ecx, 126
    looping:
    mov eax, format ; format
    push ecx
    push ecx
    push eax
    call [_printf]
    add esp, 4*2
    pop ecx
    dec ecx
    cmp ecx, 31
    jne looping
    mov esp, ebp
    pop ebp
    ret 4
    