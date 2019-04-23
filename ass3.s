%define Zero 48
%define One 49


global atoi_func,WorldLength,WorldWidth,state,finish_print,cell_from_c
global curr_index,debugFlag,our_stat_size,numOfGen,numOfFreq
global main
        extern init_co, start_co, resume
        extern scheduler, printer, print_debug,newLine,cell,


        ;; /usr/include/asm/unistd_32.h
sys_exit:       equ   1
sys_write:      equ   4
stdout:         equ   1
state_size: equ 100*100

section .data
            col:dd 0
            ten: dd 10

section .bss
            debugFlag: resb 1
            fd: resb 4
            fileName: resb 250
            WorldLength: resb 4
            WorldWidth: resb 4
            numOfGen: resb 4
            numOfFreq:resb 4
            state: resb state_size
            currChar: resd 1
            our_stat_size: resb 4
            curr_index: resb 4
            toCheck: resb 10000
            
section .rodata
            Sys_read    equ 3
            Sys_Open    equ 5
            Sys_close   equ 6
            O_RDONLY    equ 0
            O_RDWR      equ 2
            Permission  equ 0x777
            

section .text
        
;---------- *** our main *** ----------
main:   
        push ebp
        mov ebp,esp
        sub esp,4
              
        mov ebx,dword[ebp+8]    ;ebx=argc
        mov esi,0
        cmp ebx,7   ;this check for debug mode
        je debug_mode
        
do_it:
        call Game_Of_Life

        mov ebx,0
        mov edx,scheduler   ;we put in 0 the scheduler
        call init_co        ;start the init
        inc ebx             ;mov ebx to 1
        mov edx,printer     ;1 saved the printer
        call init_co        ;and init it
    
        inc byte[our_stat_size]
        
;---------- ***init the cells co-routines *** -----------
  
;here we make a loop to init our cells,inc ebx and put the "func" cell_from_c

 init_our_cells:            
        inc ebx
        mov edx,cell_from_c
        
        call init_co
        
        cmp ebx,[our_stat_size]
        jl init_our_cells
        
        dec byte[our_stat_size]
        
;---------- *** start the Program *** ----------
        mov ebx,0 
    
        call start_co
    
end_game:
        mov esp,ebp
        pop ebp
        ret
        
        mov eax,sys_exit
        mov ebx,0
        int 80h
        
;------------------- *** The Game *** ---------------------------

Game_Of_Life:
        mov ecx,dword[ebp+12]
        
        mov eax,[ecx+4+esi]
        mov [fileName],eax
        
; ------ *** length *** -----	
        
        mov eax,[ecx+8+esi]         ; take from argv input
        mov [WorldLength],eax       ; put in the varibale WorldLength
        push dword[WorldLength]     ; push to stack
        call atoi_func              ; convert from char to int
        mov [WorldLength],eax       ; put result in the varibale
        add esp,4                   ; remove push


; ------ *** width *** -----	

        mov eax,[ecx+12+esi]        ; take from argv input
        mov [WorldWidth],eax        ; put in the varibale WorldWidth
        push dword[WorldWidth]      ; push to stack
        call atoi_func              ; convert from char to int
        mov [WorldWidth],eax        ; put result in the varibale
        add esp,4                   ; remove push
    
; ----- *** num of gen *** -----
        mov eax,[ecx+16+esi]        ; take from argv input
        mov [numOfGen],eax          ; put in the varibale numOfGen
        push dword[numOfGen]        ; push to stack
        call atoi_func              ; convert from char to int
        mov [numOfGen],eax          ; put result in the varibale
        add esp,4                   ; remove push
        
; ----- *** num of freq *** -----
        mov eax,[ecx+20+esi]        ; take from argv input
        mov [numOfFreq],eax         ; put in the varibale numOfFreq
        push dword[numOfFreq]       ; push to stack
        call atoi_func              ; convert from char to int
        mov [numOfFreq],eax         ; put result in the varibale
        add esp,4                   ; remove push
        
        mov ebx, [WorldLength]      ; i*j=num of cells
        mov eax, [WorldWidth]
        imul ebx
        mov [our_stat_size], eax    ; here we save the size of state (i*j)
    
; ----- *** print argv for debug or not *** -----

        cmp byte[debugFlag],1       ; check for debug mode
        je print_debug              ; if in debug wer going to our print_debug in our printer
        
; ----- *** finish show the input *** -----
        
finish_print: ;we did it just for make a "flag" to come back here after print debug
     
no_need_to_print_argv:
; ---------- *** sys open *** ----------

        mov eax,Sys_Open
        mov ebx,[fileName]
        mov ecx,O_RDONLY
        mov edx,Permission
        int 80h
        
        mov [fd],eax

;---------- *** end of open *** ----------

;---------- *** system call read *** ----------
read_file:  ;here we make a loop and reading one "byte" (char) from the file
    mov dword[currChar],0            
    mov eax,Sys_read
    mov ebx,[fd]
    mov ecx,currChar
    mov edx,1   ;byte to read
    int 80h
;---------- *** end of read *** ----------

    mov ebx,0
    mov ebx,[currChar]
    cmp ebx,0
    je finish_loop
    
    cmp bl,' '  ;check for space
    je add_zero
    cmp bl,'1'  ;check for one
    je add_one
    jmp read_file
    
add_zero:       ;add 0 for state
        mov bl,Zero
        jmp add_to_matrix
        
add_one:        ;add 1 for state
        mov bl,One
        jmp add_to_matrix
        
add_to_matrix:
        mov esi,dword[curr_index]
        mov byte[state+esi],bl
        
        inc esi
        mov dword[curr_index],esi
        
        jmp read_file
        
;---------- *** system call of close *** ----------
finish_loop:
        mov eax,Sys_close
        mov ebx,[fd]
        int 80h
;---------- *** end of close *** ----------
        cmp byte[debugFlag],1 
        je print_state
        jmp no_need_to_print_state
 
;--------- *** finish reading the file *** ----------

;---------- *** debug mod *** ----------
debug_mode:
        mov byte[debugFlag],1
        add esi,4   ;debug mode- argv move in 4
        jmp do_it 
        
;---------- *** end of debug *** ----------

print_state:
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
        
        ;mov esp,ebp
        ;pop ebp
        ret
;---------- *** end game *** -----------

no_need_to_print_state:


;----- *** atoi func *** -----
; we get this atoi func from caspl 142!!!
atoi_func:
        push    ebp
        mov     ebp, esp        ; Entry code - set up ebp and esp
        push ecx
        push edx
        push ebx
        mov ecx, dword [ebp+8]  ; Get argument (pointer to string)
        xor eax,eax
        xor ebx,ebx
atoi_loop:
        xor edx,edx
        cmp byte[ecx],0
        jz  atoi_end
        imul dword[ten]
        mov bl,byte[ecx]
        sub bl,'0'
        add eax,ebx
        inc ecx
        jmp atoi_loop
atoi_end:
        pop ebx                 ; Restore registers
        pop edx
        pop ecx
        mov     esp, ebp        ; Function exit code
        pop     ebp
        ret
;---------- *** END OF ATOI *** ----------
    
;---------- *** START CELL FROM C *** ----------
cell_from_c:
        call cell
        mov ebx,0 ;resume for scheduler
        call resume 
        
get_value_from_c:
        mov ebx,[esp]   ;this is our row 
        mov ecx,[esp+4] ;this is the col
        mov esi,eax     ;put in esi the value from cell
        mov eax,[WorldWidth]    ;put in eax the WorldWidth
        mul ebx              
        add eax,ecx
        add eax,state
        mov ecx,0
        mov edx,0
        mov edx,esi
        
        mov byte[eax],dl
        mov ebx,0
        call resume
        jmp cell_from_c
        
      
    
    
    