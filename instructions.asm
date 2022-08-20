section .data:
    global IS_NEGATIVE
    global IS_POSITIVE

    execute_add_msg db 'execute_add', 0dH, 0ah
    execute_add_size equ $-execute_add_msg

    execute_sub_msg db 'execute_sub', 0dH, 0ah
    execute_sub_size equ $-execute_sub_msg

    execute_mult_msg db 'execute_mult', 0dH, 0ah
    execute_mult_size equ $-execute_mult_msg

    execute_div_msg db 'execute_div', 0dH, 0ah
    execute_div_size equ $-execute_div_msg

    execute_jmp_msg db 'execute_jmp', 0dH, 0ah
    execute_jmp_size equ $-execute_jmp_msg

    execute_jmpn_msg db 'execute_jmpn', 0dH, 0ah
    execute_jmpn_size equ $-execute_jmpn_msg

    execute_jmpp_msg db 'execute_jmpp', 0dH, 0ah
    execute_jmpp_size equ $-execute_jmpp_msg

    execute_jmpz_msg db 'execute_jmpz', 0dH, 0ah
    execute_jmpz_size equ $-execute_jmpz_msg

    execute_copy_msg db 'execute_copy', 0dH, 0ah
    execute_copy_size equ $-execute_copy_msg

    execute_load_msg db 'execute_load', 0dH, 0ah
    execute_load_size equ $-execute_load_msg

    execute_store_msg db 'execute_store', 0dH, 0ah
    execute_store_size equ $-execute_store_msg

    execute_input_msg db 'execute_input', 0dH, 0ah
    execute_input_size equ $-execute_input_msg

    execute_output_msg db 'execute_output', 0dH, 0ah
    execute_output_size equ $-execute_output_msg

    IS_NEGATIVE equ 1
    IS_POSITIVE equ 0


section .text:


extern print_screen
extern get_next_number
extern set_number_object_file
extern get_number_object_file
extern accumulator
extern program_counter
extern print_int
extern buffer
extern stoi
extern to_string
extern SIZE
extern print_screen_log
extern print_int_log


global execute_add
global execute_sub
global execute_mult
global execute_div
global execute_jmp
global execute_jmpn
global execute_jmpp
global execute_jmpz
global execute_copy
global execute_load
global execute_store
global execute_input
global execute_output
global get_sign


; Brief: Gets the value of the label and adds to the accumulator
; Declaration: void execute_add();
; Params:
; Local variables:
; Return:
;   - None
execute_add:
    enter 0,0
    
    push dword execute_add_msg
    push dword execute_add_size
    call print_screen_log

    call get_next_number
    push eax
    call get_number_object_file
    add [accumulator], eax

    push dword [accumulator]
    call print_int_log

    leave
    ret


; Brief: Gets the value of the label and subtracts to the accumulator
; Declaration: void execute_sub();
; Params:
; Local variables:
; Return:
;   - None
execute_sub:
    enter 0,0
    
    push dword execute_sub_msg
    push dword execute_sub_size
    call print_screen_log

    call get_next_number
    push eax
    call get_number_object_file
    sub [accumulator], eax

    push dword [accumulator]
    call print_int_log

    leave
    ret


; Brief: Gets the value of the label and multiply to the accumulator
; Declaration: void execute_mult();
; Params:
; Local variables:
    %define em_number1 dword [ebp-04]
    %define em_number2 dword [ebp-08]
    %define em_sign_number1 dword [ebp-12]
    %define em_sign_number2 dword [ebp-16]
; Return:
;   - None
execute_mult:
    enter 16,0
    
    push dword execute_mult_msg
    push dword execute_mult_size
    call print_screen_log

    ; Get the abs value of the accumulator and its sign
    push dword [accumulator]
    call get_abs_value
    mov em_number1, eax
    push dword [accumulator]
    call get_sign
    mov em_sign_number1, eax

    ; Get the next number content
    call get_next_number
    push eax
    call get_number_object_file

    ; Get the abs value of the first operand memory content
    push eax  ; save the original value
    push eax
    call get_abs_value
    mov em_number2, eax
    pop eax     ; get the original value
    push eax
    call get_sign
    mov em_sign_number2, eax

    push dword em_number1
    call print_int_log
    push dword em_number2
    call print_int_log


    ; Multiply em_number1 x em_number2
    mov eax, em_number1
    mov ebx, em_number2
    mul ebx

    ; Resolve the sign of the multiplication
    mov ebx, em_sign_number1
    xor ebx, em_sign_number2
    cmp ebx, IS_NEGATIVE
    jne .em_is_positive
        neg eax
    .em_is_positive:

    mov [accumulator], eax

    push dword [accumulator]
    call print_int_log

    leave
    ret


; Brief: Gets the value of the label and multiply to the accumulator
; Declaration: void execute_div();
; Params:
; Local variables:
    %define ed_number1 dword [ebp-04]
    %define ed_number2 dword [ebp-08]
    %define ed_sign_number1 dword [ebp-12]
    %define ed_sign_number2 dword [ebp-16]
; Return:
;   - None
execute_div:
    enter 16,0
    
    push dword execute_div_msg
    push dword execute_div_size
    call print_screen_log
    
    ; Get the abs value of the accumulator and its sign
    push dword [accumulator]
    call get_abs_value
    mov ed_number1, eax
    push dword [accumulator]
    call get_sign
    mov ed_sign_number1, eax

    ; Get the next number content
    call get_next_number
    push eax
    call get_number_object_file

    ; Get the abs value of the first operand memory content
    push eax  ; save the original value
    push eax
    call get_abs_value
    mov ed_number2, eax
    pop eax     ; get the original value
    push eax
    call get_sign
    mov ed_sign_number2, eax

    push dword ed_number1
    call print_int_log
    push dword ed_number2
    call print_int_log

    ; Divide ed_number1 x ed_number2
    mov eax, ed_number1
    mov ebx, ed_number2
    mov edx, 0
    div ebx

    ; Resolve the sign of the multiplication
    mov ebx, ed_sign_number1
    xor ebx, ed_sign_number2
    cmp ebx, IS_NEGATIVE
    jne .ed_is_positive
        neg eax
    .ed_is_positive:

    mov [accumulator], eax
    
    push dword [accumulator]
    call print_int_log
    
    leave
    ret


; Brief: Jumps to the position of the operand
; Declaration: void execute_jmp();
; Params:
; Local variables:
; Return:
;   - None
execute_jmp:
    enter 0,0
    
    push dword execute_jmp_msg
    push dword execute_jmp_size
    call print_screen_log

    call get_next_number
    mov [program_counter], eax

    push dword [program_counter]
    call print_int_log
    
    leave
    ret


; Brief: Jumps to the position of the operand if accumulator is less then zero
; Declaration: void execute_jmpn();
; Params:
; Local variables:
    %define ejn_value dword [ebp-04]
; Return:
;   - None
execute_jmpn:
    enter 4,0
    
    push dword execute_jmpn_msg
    push dword execute_jmpn_size
    call print_screen_log

    call get_next_number
    mov ejn_value, eax

    ; Verify if the 
    push dword [accumulator]
    call get_sign
    cmp eax, IS_NEGATIVE
    jne .ejn_is_positive 
        mov eax, ejn_value
        mov [program_counter], eax
    .ejn_is_positive:

    push dword [program_counter]
    call print_int_log

    leave
    ret


; Brief: Jumps to the position of the operand if accumulator is greater then zero
; Declaration: void execute_jmpp();
; Params:
; Local variables:
    %define ejp_value dword [ebp-04]
; Return:
;   - None
execute_jmpp:
    enter 4,0
    
    push dword execute_jmpp_msg
    push dword execute_jmpp_size
    call print_screen_log

    call get_next_number
    mov ejp_value, eax

    ; If the number is negative, dont jump
    push dword [accumulator]
    call get_sign
    cmp eax, IS_NEGATIVE
    je .notgreaterzero

    ; If the value greater than 0, jump
    cmp [accumulator], dword 0
    jbe .notgreaterzero
        mov eax, ejp_value
        mov [program_counter], eax
    .notgreaterzero:

    push dword [program_counter]
    call print_int_log

    leave
    ret


; Brief: Jumps to the position of the operand if accumulator is equals to zero
; Declaration: void execute_jmpz();
; Params:
; Local variables:
; Return:
;   - None
execute_jmpz:
    enter 0,0
    
    push dword execute_jmpz_msg
    push dword execute_jmpz_size
    call print_screen_log

    call get_next_number
    cmp [accumulator], dword 0
    jne .notequalsrzero
        mov [program_counter], eax
    .notequalsrzero:

    push dword [program_counter]
    call print_int_log

    leave
    ret


; Brief: Copy the content of the first operand to the position on second operand
; Declaration: void execute_copy();
; Params:
; Local variables:
; Return:
;   - None
execute_copy:
    enter 0,0
    
    push dword execute_copy_msg
    push dword execute_copy_size
    call print_screen_log

    ; Get first operand
    call get_next_number
    
    push eax
    call get_number_object_file
    push eax
    push eax
    call print_int_log
    pop eax
    
    push eax ; Save the value of the first operand

    ; Get second operand
    call get_next_number
    pop ebx
    push eax ; debug
    push eax
    push ebx
    call set_number_object_file

    pop eax
    push eax
    call get_number_object_file
    push eax
    call print_int_log

    leave
    ret


; Brief: Load the value of the momory of the operand into the accumulator
; Declaration: void execute_load();
; Params:
; Local variables:
; Return:
;   - None
execute_load:
    enter 0,0
    
    push dword execute_load_msg
    push dword execute_load_size
    call print_screen_log

    call get_next_number
    push eax 
    call get_number_object_file
    mov [accumulator], eax

    push dword [accumulator]
    call print_int_log
    
    leave
    ret


; Brief: Store the value of the accumulator into the position of the first operand
; Declaration: void execute_store();
; Params:
; Local variables:
; Return:
;   - None
execute_store:
    enter 0,0
    
    push dword execute_store_msg
    push dword execute_store_size
    call print_screen_log

    call get_next_number
    push eax ; debug, save the position of the operand
    push eax 
    push dword [accumulator]
    call set_number_object_file

    pop eax
    push eax
    call get_number_object_file
    push eax
    call print_int_log

    leave
    ret
    

; Brief: Get the input from keyboard and store it into the first operand
; Declaration: void execute_input();
; Params:
; Local variables:
; Return:
;   - None
execute_input:
    enter 0,0
    
    push dword execute_input_msg
    push dword execute_input_size
    call print_screen_log

    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, SIZE
    int 0x80
    push buffer
    dec eax
    push eax
    call stoi 
    push eax ; save the converted integer

    push eax
    call print_int_log

    call get_next_number
    pop ebx
    push eax
    push ebx
    call set_number_object_file

    leave
    ret


; Brief: Prints the output of a value in memory of the operand
; Declaration: void execute_output();
; Params:
; Local variables:
; Return:
;   - None
execute_output:
    enter 0,0
    
    push dword execute_output_msg
    push dword execute_output_size
    call print_screen_log

    call get_next_number
    push eax
    call get_number_object_file
    push eax
    call print_int
    
    leave
    ret


; Brief: Get the absolute value of an int
; Declaration: int get_abs_value(int absolute_value)
; Params:
    %define absolute_value dword [ebp+08] ; Value to convert
; Local variables:
; Return:
;   - EAX: Returns the absolute value
get_abs_value:
    enter 0,0
        
    mov eax, absolute_value
    test eax, eax
    js .a_negative
        jmp .a_end
    .a_negative:
    neg eax
    .a_end:

    ;push eax
    ;push eax
    ;call print_int_log
    ;pop eax

    leave
    ret 4


; Brief: Get the absolute value of an int
; Declaration: int get_sign(int gs_value)
; Params:
    %define gs_value dword [ebp+08] ; Value to convert
; Local variables:
; Return:
;   - EAX: Returns 0 if positive, else returns 1
get_sign:
    enter 0,0

    mov eax, gs_value
    test eax, eax
    js .gs_negative
        mov eax, IS_POSITIVE
        jmp .gs_end
    .gs_negative:
    mov eax, IS_NEGATIVE
    .gs_end:

    leave
    ret 4
