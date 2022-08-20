section .data

   global disassembly
   global disassembly_index

    read_object_file_msg db 'read_object_file', 0dH, 0ah
    read_object_file_size equ $-read_object_file_msg

    convert_chararray_to_intarray_msg db 'convert_chararray_to_intarray', 0dH, 0ah
    convert_chararray_to_intarray_size equ $-convert_chararray_to_intarray_msg

    save_output_file_msg db 'save_output_file', 0dH, 0ah
    save_output_file_size equ $-save_output_file_msg

    register_opcode_msg db 'register_opcode', 0dH, 0ah
    register_opcode_size equ $-register_opcode_msg

    disassembly_index dd 0


section .bss
    number_to_convert resb 10
    disassembly resb 10000


section .text


global read_object_file
global convert_chararray_to_intarray
global create_output_file
global save_output_file
global register_opcode
extern disassembly_file


extern SIZE
extern buffer
extern print_screen
extern print_break_log
extern stoi
extern breakline
extern to_string
extern print_screen_log 


; Brief: Read the object file and store in memory as char*
; Declaration: int read_object_file(char* filename, int size, char* buffer)
; Params:
    %define rof_filename dword [ebp+16] ; Pointer to the object file to be read
    %define rof_size     dword [ebp+12] ; Size of the filename
    %define rof_buffer   dword [ebp+08] ; Pointer to the buffer to store the object file
; Local variables:
    %define rof_file_descriptor dword [ebp-04]
; Return:
;   - Returns the number of bytes read
read_object_file:
    enter 0,0

    push dword read_object_file_msg
    push dword read_object_file_size
    call print_screen_log

    ; Print filename
    push rof_filename
    push rof_size
    call print_screen_log
    call print_break_log

    ; Open file
    mov eax, 5
    mov ebx, rof_filename
    mov ecx, 0
    mov edx, 0700
    int 0x80        

    mov rof_file_descriptor, eax

    ; Read from file to buffer
    mov ebx, eax    ; ebx = File Descriptor
    mov eax, 3
    mov ecx, rof_buffer
    mov edx, SIZE
    int 0x80

    ; Save the number of bytes read
    push eax

    ; Close file
    mov eax, 6
    mov ebx, rof_file_descriptor
    int 0x80

    ; Return number or bytes read
    pop eax

    leave
    ret 12


; Brief: Converts char* into int*
; Declaration: int convert_chararray_to_intarray(char* object_text, int size, int* object_file)
; Params:
    %define ccti_object_text dword [ebp+16] ; Pointer to the text of the object file
    %define ccti_size        dword [ebp+12] ; Size read object file
    %define ccti_object_file dword [ebp+08] ; Pointer to the buffer to store converter intergers
; Local variables:
    %define ccti_number_size dword [ebp-04] ; Size of the number to be converted in char
    %define object_file_size dword [ebp-08] ; Size of the object_file
; Return:
;   - Return the number of integers converted
convert_chararray_to_intarray:
    enter 8,0

    push convert_chararray_to_intarray_msg
    push convert_chararray_to_intarray_size
    call print_screen_log

    push dword ccti_object_text
    push dword ccti_size
    call print_screen_log

    mov ecx, dword ccti_size
    mov ccti_number_size, dword 0 ; initialize local variable
    mov object_file_size, dword 0 ; initialize local variable

    .ccti_loop:
    mov ccti_size, ecx ; Update the counter value in memory
        mov esi, dword ccti_object_text
        movzx edx, byte [esi]
        ; Compare if current char is a ' ' character
        cmp dl, ' '
        jne .ccti_not_space
            ; Convert the saved string
            push dword number_to_convert
            push dword ccti_number_size
            call stoi

            ; Save the converted integer into object_file
            mov ebx, dword ccti_object_file   ; Gets the pointer of the object_file
            mov [ebx], eax                    ; Save the integer
            add ccti_object_file, dword 4     ; Moves the object_file to the next position
            inc dword object_file_size        ; object_file_size++

            ; Set the size of the number to be converted to 0
            mov ccti_number_size, dword 0
            jmp .endif
        .ccti_not_space:
            ; Save the char to be converted and increase the size only if it is a char between '0' - '9'
            cmp edx, '-'
            je .accept
            cmp edx, '0'
            jb .endif
            cmp edx, '9'
            ja .endif
            .accept:
                mov ebx, dword number_to_convert
                add ebx, dword ccti_number_size
                mov [ebx], byte dl
                inc dword ccti_number_size
        .endif:
    inc dword ccti_object_text
    mov ecx, dword ccti_size
    loop .ccti_loop
    .ccti_end_loop:

    ; Convert the last number
    push dword number_to_convert
    push dword ccti_number_size
    call stoi

    ; Save the converted integer into object_file
    mov ebx, dword ccti_object_file   ; Gets the pointer of the object_file
    mov [ebx], eax                    ; Save the integer
    add ccti_object_file, dword 4     ; Moves the object_file to the next position
    inc dword object_file_size        ; object_file_size++

    mov eax, dword object_file_size

    leave
    ret 12


; Brief: Create the output file, write the instructions on it and close the file
; Declaration: void save_output_file(char* sof_output_filename, char* sof_content, int sof_content_size)
; Params:
    %define sof_output_filename dword [ebp+16] ; Pointer to the char* with the output filename
    %define sof_content         dword [ebp+12] ; Pointer to the char* with the content of the filename
    %define sof_content_size    dword [ebp+08] ; Size of the content in bytes
; Local variables:
    %define sof_file_descriptor dword [ebp-04] ; Pointer to the filedescriptor
; Return:
;   - None
save_output_file:
    enter 4,0

    push dword save_output_file_msg
    push dword save_output_file_size
    call print_screen_log

    ; Create and openfile on write mode
    mov eax, 8
    mov ebx, sof_output_filename
    mov ecx, 0700
    int 0x80

    mov sof_file_descriptor, eax

    mov eax, 4
    mov ebx, sof_file_descriptor
    mov ecx, sof_content
    mov edx, sof_content_size
    int 0x80

    leave
    ret 12


; Brief: Save the name of the instruction of the corresponding opcode into a char*
; Declaration: void register_opcode(char* name)
; Params:
    %define ro_opcode           dword [ebp+12] ; Pointer to the name of the opcode
    %define ro_opcode_name_size dword [ebp+08] ; Size of the name of the opcode
; Local variables:
; Return:
;   - None
register_opcode:
    enter 0,0

    push dword register_opcode_msg
    push dword register_opcode_size
    call print_screen_log

    ; Load all pointers
    mov eax, ro_opcode
    mov ebx, disassembly
    add ebx, [disassembly_index]
    ; Move each char to other char*
    mov ecx, ro_opcode_name_size
    .move_char_loop:
        mov dl, byte[eax]
        mov [ebx], byte dl
        inc eax
        inc ebx
    loop .move_char_loop

    ; Add the number of bytes read to indicate the end of the char*
    mov eax, ro_opcode_name_size
    add [disassembly_index], eax

    push dword disassembly
    push dword [disassembly_index]
    call print_screen_log
    call print_break_log

    leave
    ret 8


