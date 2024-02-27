bits 32 

global start

extern exit 
import exit msvcrt.dll  


segment data use32 class=data



segment code use32 class=code
start:
    
    push ebp; saving the caller’s  stackframe base for further being able to restore it

mov ebp,esp ; initialising the base of the new stack frame for the currently  executing 

; procedure AddTwo  (see the  picture below which illustrates exactly 

; this described situation)

mov eax,[ebp + 12] ; transferring into EAX the value of the second parameter passed 

; on to the stack by the caller BEFORE  the new stackframe takes 

; the run time control

add eax,[ebp + 8] ; adding to EAX the first parameter

pop ebp ; restoring the caller stackframe  as being the new currently executing one 

ret ; going back immediately to the point of call for continuing the execution 

  ;  of the program
    

    push dword 0 
    call [exit] 