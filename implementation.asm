section .data
    ; Messages for printing
    get_next_number_msg db 'get_next_number', 0dH, 0ah
    get_next_number_size equ $-get_next_number_msg

    get_number_object_file_msg db 'get_number_object_file', 0dH, 0ah
    get_number_object_file_size equ $-get_number_object_file_msg

    set_number_object_file_msg db 'set_number_object_file', 0dH, 0ah
    set_number_object_file_size equ $-set_number_object_file_msg

    error_not_valid_opcode_msg db '[ERROR] given opcode not valid', 0dH, 0ah
    error_not_valid_opcode_size equ $-error_not_valid_opcode_msg

    output_filename db 'out.txt', 0

    ; OPCODE definition 
    is_add    equ 1
    is_sub    equ 2
    is_mult   equ 3
    is_div    equ 4
    is_jmp    equ 5
    is_jmpn   equ 6
    is_jmpp   equ 7
    is_jmpz   equ 8
    is_copy   equ 9
    is_load   equ 10
    is_store  equ 11
    is_input  equ 12
    is_output equ 13
    is_stop   equ 14

    ; Define string names of the instructions
    add_name    db 'ADD',   0dH, 0ah
    add_name_size    equ $-add_name
    sub_name    db 'SUB',   0dH, 0ah
    sub_name_size    equ $-sub_name
    mult_name   db 'MULT',  0dH, 0ah
    mult_name_size   equ $-mult_name
    div_name    db 'DIV',   0dH, 0ah
    div_name_size    equ $-div_name
    jmp_name    db 'JMP',   0dH, 0ah
    jmp_name_size    equ $-jmp_name
    jmpn_name   db 'JMPN',   0dH, 0ah
    jmpn_name_size   equ $-jmpn_name
    jmpp_name   db 'JMPP',   0dH, 0ah
    jmpp_name_size   equ $-jmpp_name
    jmpz_name   db 'JMPZ',   0dH, 0ah
    jmpz_name_size   equ $-jmpz_name
    copy_name   db 'COPY',   0dH, 0ah
    copy_name_size   equ $-copy_name
    load_name   db 'LOAD',   0dH, 0ah
    load_name_size   equ $-load_name
    store_name  db 'STORE',  0dH, 0ah
    store_name_size  equ $-store_name
    input_name  db 'INPUT',  0dH, 0ah
    input_name_size  equ $-input_name
    output_name db 'OUTPUT', 0dH, 0ah
    output_name_size equ $-output_name
    stop_name   db 'STOP',   0dH, 0ah
    stop_name_size   equ $-stop_name

    ; Global variables
    SIZE equ 10000
    program_counter dd 0
    accumulator dd 0

    LOG_ACTIVE equ 1
    LOG_INACTIVE equ 0
    log dd LOG_INACTIVE


section .bss
    object_text resb SIZE
    object_file resb SIZE
    buffer resb SIZE

section .text


; Export labels
global simulator
global SIZE
global get_next_number
global set
global accumulator
global get_number_object_file
global set_number_object_file   
global program_counter
global buffer
global log
global LOG_ACTIVE


; Imports from convert
extern stoi
extern to_string


; Imports from print
extern print_break_log
extern print_screen
extern print_int
extern print_screen_log


; Imports from file_handler
extern read_object_file
extern convert_chararray_to_intarray
extern save_output_file
extern register_opcode
extern print_object_file
extern disassembly_file
extern disassembly
extern disassembly_index


; Imports from instructions.asm
extern execute_add
extern execute_sub
extern execute_mult
extern execute_div
extern execute_jmp
extern execute_jmpn
extern execute_jmpp
extern execute_jmpz
extern execute_copy
extern execute_load
extern execute_store
extern execute_input
extern execute_output
extern execute_stop


; Brief: Reads  a object file and execute it. Also, creates a file with the name of the executed instructions and print the number of instructions read
; Declaration: void simulator(char* filename, int length)
; Params:
    %define filename dword [ebp+08] ; Name of the object file to be executed
    %define length   dword [ebp+12] ; The size of the name of the objectfile
; Local variables:
    %define current_opcode dword [ebp-4]
; Return:
;   - None
simulator:
    enter 4,0

    push filename
    push length
    push object_text
    call read_object_file

    push object_text    ; Pointer to the buffer
    push eax            ; Number of bytes read
    push object_file    ; Pointer to the buffer of int*
    call convert_chararray_to_intarray

    push dword object_file
    push eax
    call print_object_file

    push dword object_file
    call disassembly_file

    .while:
        call get_next_number
        mov current_opcode, eax
        ; DEBUG
        push eax
        push dword buffer
        push dword SIZE
        call to_string
        push eax
        push ebx
        call print_screen_log
        call print_break_log
        ; DEBUG

        ; switch (opcode(eax)):
        ; case add:
        cmp current_opcode, is_add
        jnz .casesub
            call execute_add
            jmp .end_case  

        .casesub:
        cmp current_opcode, is_sub
        jnz .casemult
            call execute_sub
            jmp .end_case 
        
        .casemult:
        cmp current_opcode, is_mult
        jnz .casediv
            call execute_mult
            jmp .end_case 
        
        .casediv:
        cmp current_opcode, is_div
        jnz .casejmp
            call execute_div
            jmp .end_case 
        
        .casejmp:
        cmp current_opcode, is_jmp
        jnz .casejmpn
            call execute_jmp
            jmp .end_case 
        
        .casejmpn:
        cmp current_opcode, is_jmpn
        jnz .casejmpp
            call execute_jmpn
            jmp .end_case 
        
        .casejmpp:
        cmp current_opcode, is_jmpp
        jnz .casejmpz
            call execute_jmpp
            jmp .end_case 
        
        .casejmpz:
        cmp current_opcode, is_jmpz
        jnz .casecopy
            call execute_jmpz
            jmp .end_case 
        
        .casecopy:
        cmp current_opcode, is_copy
        jnz .caseload
            call execute_copy
            jmp .end_case 
        
        .caseload:
        cmp current_opcode, is_load
        jnz .casestore
            call execute_load
            jmp .end_case 
        
        .casestore:
        cmp current_opcode, is_store
        jnz .caseinput
            call execute_store
            jmp .end_case 
        
        .caseinput:
        cmp current_opcode, is_input
        jnz .caseoutput
            call execute_input
            jmp .end_case 
        
        .caseoutput:
        cmp current_opcode, is_output
        jnz .casestop
            call execute_output
            jmp .end_case 
        
        .casestop:
        cmp current_opcode, is_stop
        jnz .casedefault
            jmp .end_while
        
        .casedefault:
            ; Default case is just print error message and end execution
            push dword error_not_valid_opcode_msg
            push dword error_not_valid_opcode_size
            call print_screen
            ; End Execution
            jmp .end_while
        .end_case:

        call print_break_log
        call print_break_log
        jmp .while
    .end_while:

    push output_filename
    push disassembly
    push disassembly_index
    call save_output_file

    ; Print the number of bytes read
    push dword [disassembly_index]
    call print_int

    mov eax, disassembly_index ; return the number of bytes written on file

    leave
    ret


; Brief: Get the next value on object file, increase program counter value and returns to eax
; Declaration: int get_next_number(program_counter)
; Params:
; Local variables:
; Return:
;   - Returns the value on memory of the next position of the object file program counter
get_next_number:
    enter 0,0

    push dword get_next_number_msg
    push dword get_next_number_size
    call print_screen_log

    mov esi, [program_counter]
    mov eax, [object_file+esi*4]
    inc dword [program_counter]

    leave
    ret


; Brief: Get the element on the object file on index position
; Declaration: int get_number_object_file(index);
; Params:
    %define gnof_index dword [ebp+08] ; Index to be accessed on the object file
; Local variables:
; Return:
;   - Returns the value on memory of the index position of the object file program counter
get_number_object_file:
    enter 0,0

    push dword get_number_object_file_msg
    push dword get_number_object_file_size
    call print_screen_log

    mov esi, gnof_index
    mov eax, [object_file+esi*4]

    leave
    ret 4


; Brief: Set the element on the object file on index position
; Declaration: void set_number_object_file(index, value);
; Params:
    %define snof_index dword [ebp+12] ; Index to be accessed on the object file
    %define snof_value dword [ebp+08] ; Value to be set
; Local variables:
; Return:
;   - None
set_number_object_file:
    enter 0,0

    push dword set_number_object_file_msg
    push dword set_number_object_file_size
    call print_screen_log

    mov esi, snof_index
    mov eax, snof_value
    mov [object_file+esi*4], eax

    leave
    ret 8


; Brief: Realize the disassembly of the object_file
; Declaration: void disassembly_file(int* object_file)
; Params:
    %define df_object_file dword [ebp+08] ; Pointer to the integers of the object file
; Local variables:
    %define df_current_opcode dword [ebp-04] ; 
; Return:
;   - None
disassembly_file:
    enter 4,0
        .while:
        mov eax, df_object_file
        mov eax, [eax]
        mov df_current_opcode, eax
        add df_object_file, dword 4

        ; switch (opcode(eax)):
        ; case add:
        cmp df_current_opcode, is_add
        jnz .casesub
            add df_object_file, dword 4
            push dword add_name
            push dword add_name_size
            call register_opcode
            jmp .end_case  

        .casesub:
        cmp df_current_opcode, is_sub
        jnz .casemult
            add df_object_file, dword 4
            push dword sub_name
            push dword sub_name_size
            call register_opcode
            jmp .end_case 
        
        .casemult:
        cmp df_current_opcode, is_mult
        jnz .casediv
            add df_object_file, dword 4
            push dword mult_name
            push dword mult_name_size
            call register_opcode
            jmp .end_case 
        
        .casediv:
        cmp df_current_opcode, is_div
        jnz .casejmp
            add df_object_file, dword 4
            push dword div_name
            push dword div_name_size
            call register_opcode
            jmp .end_case 
        
        .casejmp:
        cmp df_current_opcode, is_jmp
        jnz .casejmpn
            add df_object_file, dword 4
            push dword jmp_name
            push dword jmp_name_size
            call register_opcode
            jmp .end_case 
        
        .casejmpn:
        cmp df_current_opcode, is_jmpn
        jnz .casejmpp
            add df_object_file, dword 4
            push dword jmpn_name
            push dword jmpn_name_size
            call register_opcode
            jmp .end_case 
        
        .casejmpp:
        cmp df_current_opcode, is_jmpp
        jnz .casejmpz
            add df_object_file, dword 4
            push dword jmpp_name
            push dword jmpp_name_size
            call register_opcode
            jmp .end_case 
        
        .casejmpz:
        cmp df_current_opcode, is_jmpz
        jnz .casecopy
            add df_object_file, dword 4
            push dword jmpz_name
            push dword jmpz_name_size
            call register_opcode
            jmp .end_case 
        
        .casecopy:
        cmp df_current_opcode, is_copy
        jnz .caseload
            add df_object_file, dword 4
            add df_object_file, dword 4
            push dword copy_name
            push dword copy_name_size
            call register_opcode
            jmp .end_case 
        
        .caseload:
        cmp df_current_opcode, is_load
        jnz .casestore
            add df_object_file, dword 4
            push dword load_name
            push dword load_name_size
            call register_opcode
            jmp .end_case 
        
        .casestore:
        cmp df_current_opcode, is_store
        jnz .caseinput
            add df_object_file, dword 4
            push dword store_name
            push dword store_name_size
            call register_opcode
            jmp .end_case 
        
        .caseinput:
        cmp df_current_opcode, is_input
        jnz .caseoutput
            add df_object_file, dword 4
            push dword input_name
            push dword input_name_size
            call register_opcode
            jmp .end_case 
        
        .caseoutput:
        cmp df_current_opcode, is_output
        jnz .casestop
            add df_object_file, dword 4
            push dword output_name
            push dword output_name_size
            call register_opcode
            jmp .end_case 
        
        .casestop:
        cmp df_current_opcode, is_stop
        jnz .casedefault
            push dword stop_name
            push dword stop_name_size
            call register_opcode
            jmp .end_while
        
        .casedefault:
            ; Default case is just print error message and end execution
            push dword error_not_valid_opcode_msg
            push dword error_not_valid_opcode_size
            call print_screen
            ; End Execution
            mov eax, 1
            int 0x80
        .end_case:

        jmp .while
    .end_while:

    leave 
    ret 4

