extern WorldLength,WorldWidth,state,our_stat_size,resume,end_co,numOfGen,numOfFreq

global scheduler

section .data
        arr_size_plus_1: dd 0
        freq_steps: dd 0      ; cont num of freq
        gen_steps: dd 0      ; cont num of gen


section .text
;------------------ *** beginning of Scheduler ***-----------------------
scheduler:
        mov esi,[esp]
        ;mov esi,[numOfGen]
        add esi,esi

	mov ebx, 2 ; init- first cell

start:
        mov edi,[esp+4]
        ;mov edi,[numOfFreq]
	cmp [gen_steps],esi ; done all gen- end game
	je end_game
;------------------ ** Loop for all cells in one gen ***------------------
cells_loop:
        mov ecx,0
	mov ecx, [numOfFreq]
	cmp dword[freq_steps],ecx ; check if its time to print
	je call_printer
        call resume
        add dword[freq_steps],1   ; next freq
	mov eax,0
	mov eax, [our_stat_size] ; i*j
	mov [arr_size_plus_1], eax
	add dword[arr_size_plus_1],1 ; add 2 for printer and scheduler
	cmp ebx,[arr_size_plus_1]    ; end of gen
 	jne next_cell

next_gen:
        mov ebx, 2             ;init to first cell
        add dword[gen_steps],1 ; move to next gen
	jmp con

next_cell:
	inc ebx
	jmp cells_loop
        

con:
	cmp [gen_steps],esi ; check if done all gen- end game
	je end_game
	jmp cells_loop

;---------------------- *** printer- after k steps (num of freq) print ***--------------

call_printer:
    mov dword[freq_steps],0 ; reset k steps- num of freq		
    push ebx
    mov ebx, 1
    call resume
    pop ebx
  
    jmp start
;---------------------- *** end game- print the matrix last time ***---------------------
end_game:
        mov dword[freq_steps],0 ; reset k steps- num of freq		
        push ebx
        mov ebx, 1
        call resume
        pop ebx
        mov ebx,1       ;end
        call resume
        call end_co