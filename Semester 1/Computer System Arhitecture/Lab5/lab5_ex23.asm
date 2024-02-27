
;A byte string S is given. Obtain in the string D the set of the elements of S.
;Example:
;S: 1, 4, 2, 4, 8, 2, 1, 1
;D: 1, 2, 4, 8

;What I need to do : 
;-get an element from the array S, then loop through D and check if it is present there
;if not, WE ADD the respective element to the second array
;if yes, WE DO NOT ADD the respective element to the array
;-the first element from the first array can be automatically passed to the second array, since it can't have been duplicated yet

bits 32 

global  start 

extern  exit 

import  exit msvcrt.dll
        
segment  data use32 class=data  
        s1 db 1, 4, 2, 4, 8, 2, 1, 1
        lens1 equ $ - s1 ;the lenght of the array
        s2 times lens1 db 0 ;initialize the array where we compute the result with the same size as the initial one
                            
segment  code use32 class=code 
    start: 
        
       mov ecx, lens1 
       mov esi, 0 ;index for the first array
       mov edi, 0 ;index for the second array
       mov al, [s1+esi]
       mov [s2+edi], al ; the first element from the second array is now 1(THE FIRST EL. FROM THE FIRST ARRAY)
       jecxz finish
       while_1:
            mov al, [s1+esi] ; we move the respective element from the first array into al
            mov ebp, 0 ;ebp goes through the second array and checks element with the respective one from the first array
            while_2: ;we go through this while ebp <= edi
                mov bl, [s2+ebp] ;current value
                cmp al, bl ;compare element from array1 with the elements from array2
                je not_add_array2
                cmp ebp, edi ;we check if the current position is lower or equal than the maximum size of the second array
                jle check ;checks if we can still loop through the second array
            jmp add_array2
            
            check:
            inc ebp
            jmp while_2
            
            not_add_array2:
                inc esi ;we just go to the next element in the first array since we can't add the previous one
                dec ecx
                cmp ecx, 0
                je finish
                jmp while_1
            
            add_array2:
                inc edi ;we increment to move to the next position
                mov[s2+edi], al ;we move the corresponding element into the second array
                inc esi
                cmp ecx, 0
                je finish
        
       loop while_1
        finish:
        ;exit(0)
	
	push   dword 0 ;saves on stack the parameter of the function exit
	call   [exit] ; function exit is called in order to end the execution of