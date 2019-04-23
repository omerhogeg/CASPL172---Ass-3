%define Space 32

global printer
global print_debug,newLine
extern resume,atoi_func,WorldLength,WorldWidth,state,finish_print


        ;; /usr/include/asm/unistd_32.h
sys_write:      equ   4
stdout:         equ   1
sys_exit:       equ   1

section .data
            curr_WorldWidth: dd 32,0
            odd_line:db 0
            newLine:db '' ,10,0
            space:db Space,0
            hello:db 'hello', 10
            theFileName: db 'file name is ',10
            length: db 'length=', 10
            width:  db 'width=', 10
            numGen:   db 'number of generations=', 10
            freq:   db 'print frequency=', 10

section .text


printer:
    mov ecx,state      ;put the matrix in ecx
    mov eax,0          ;init eax,esi,edi
    mov esi,0
    mov edi,0
    
loop_print:
    mov ecx,state
    mov dl,[ecx+esi]  ;get cell
    cmp dl,0          ;check for null i.e end of matrix
    je end_print
    push edx
    mov ecx, esp
    mov eax, sys_write
    mov ebx, stdout
    mov edx,1
    int 0x80
    add esp,4
    inc esi
    inc edi
    cmp edi,[WorldWidth]
    je new_line
    jmp loop_print
        

        
new_line:
        mov edi,0
        mov eax,sys_write   ;for new line
        mov ebx,stdout
        mov ecx,newLine
        mov edx,1
        int 80h
        jmp loop_print

end_print:
        ;mov eax,sys_write   ;for new line between evry matrix
        ;mov ebx,stdout
        ;mov ecx,newLine
        ;mov edx,1
        ;int 80h
        
        mov ebx,0
        call resume             ; resume scheduler= co-routine 0
        jmp printer             

        
;----- *** the debug printer *** -----
print_debug:
        mov eax,sys_write   ;print file name
        mov ebx,stdout
        mov ecx,theFileName
        mov edx,13
        int 80h
        
        mov ecx,dword[ebp+12]
        mov ebx,stdout
        mov ecx,[ecx+4+esi]
        call check_size
        mov edx,eax
        mov eax,sys_write 
        int 80h
        
        
        mov eax,sys_write   ;for new line
        mov ebx,stdout
        mov ecx,newLine
        mov edx,1
        int 80h
    

        mov eax,sys_write   ;print length
        mov ebx,stdout
        mov ecx,length
        mov edx, 7
        int 80h
        
        mov ecx,dword[ebp+12]
        mov ebx,stdout
        mov ecx,[ecx+8+esi]
        call check_size
        mov edx,eax
        mov eax,sys_write 
        int 80h
        

        mov eax,sys_write   ;for new line
        mov ebx,stdout
        mov ecx,newLine
        mov edx,1
        int 80h
        
        
        mov eax,sys_write   ;print the width
        mov ebx,stdout
        mov ecx,width
        mov edx, 6
        int 80h
        
        mov ecx,dword[ebp+12]
        mov ebx,stdout
        mov ecx,[ecx+12+esi]
        call check_size
        mov edx,eax
        mov eax,sys_write   ;print the width number
        int 80h
        
        
        mov eax,sys_write   ;for new line
        mov ebx,stdout
        mov ecx,newLine
        mov edx,1
        int 80h
        
        
        mov eax,sys_write   
        mov ebx,stdout
        mov ecx,numGen
        mov edx, 22
        int 80h
        
        mov ecx,dword[ebp+12]
        mov ebx,stdout
        mov ecx,[ecx+16+esi]
        call check_size
        mov edx,eax
        mov eax,sys_write   ;print the length number
        int 80h
        
        
        mov eax,sys_write   ;for new line
        mov ebx,stdout
        mov ecx,newLine
        mov edx,1
        int 80h
        
        
        mov eax,sys_write   ;print the freq 
        mov ebx,stdout
        mov ecx,freq
        mov edx, 16
        int 80h
        
        mov ecx,dword[ebp+12]
        mov ebx,stdout
        mov ecx,[ecx+20+esi]
        call check_size
        mov edx,eax
        mov eax,sys_write   ;print the freq number
        int 80h
        
        mov eax,sys_write   ;for new line
        mov ebx,stdout
        mov ecx,newLine
        mov edx,1
        int 80h
        
        jmp finish_print
        
        ; exit
        mov eax, sys_exit
        xor ebx, ebx
        int 80h

;----- *** check for size *** -----
        
;----- *** strlen *** -----
check_size:   
    push  ecx            ; save and clear out counter
    mov eax,0


_strlen_next:
    cmp  byte[ecx],0     ; null byte yet?
    jz    _strlen_null   ; yes, get out
    inc   eax            ; char is ok, count it
    inc   ecx            ; move to next char
    jmp   _strlen_next   ; process again
 

_strlen_null:
    pop  ecx             ; restore ebx
    ret                  ; get out
;----- *** end of strlen *** -----