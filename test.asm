section .data

    IS_NEGATIVE equ 1
    IS_POSITIVE equ 0
    breakline db 0dH, 0ah


    STRING_TERMINATOR equ 0

    teste db '-12', 0
    teste_size equ $-teste

section .bss
    buffer resb 1000

section .text

global simulator

simulator:
    enter 0,0

    push dword teste
    mov eax, teste_size
    dec eax
    push dword eax
    call stoi

    push dword eax
    push dword buffer
    push dword 1000
    call to_string

    push eax
    push ebx
    call print_screen
    call print_break

    leave
    ret
    




; Brief: Convert string to int
; Declaration: void stoi(char* string, int length)
; Params:
    %define sti_string dword [ebp+12] ; Pointer to the string to be converted
    %define sti_length dword [ebp+08] ; The size of the string
; Local variables:
    %define sti_sign dword [ebp-04] ; The sign of the number to be converted
; Return:
;   - Returns the value of the converted string
stoi:
    enter 4,0

    mov sti_sign, IS_POSITIVE ; initialize the local variable

    ; I couldnt compare with '-' char, so i will compare if the char is numeric, if not is a '-' char
    mov edx, sti_string
    movzx edx, byte [edx]
    cmp dl, '-'
    jne .sti_is_positive
        inc sti_string ; ignore the '-' character
        mov sti_sign, dword IS_NEGATIVE
        dec sti_length  
    .sti_is_positive:

    sub ebx, ebx
    mov esi, sti_string
    mov ecx, sti_length

    .next:
    movzx eax, byte [esi]
    inc esi
    sub al,'0'
    imul ebx, 10
    add ebx, eax
    loop .next
    
    mov eax, ebx

    cmp sti_sign, dword IS_NEGATIVE
    jne .sti_is_positive2
        neg eax
    .sti_is_positive2:

    leave
    ret 8


; Brief: Convert int to string
; Declaration: void to_string(int value, char* buffer, int size)
; Params:
    %define ts_value  dword [ebp+16] ; Integer to be converted 
    %define ts_buffer dword [ebp+12] ; Pointer to the string to be converted
    %define ts_size   dword [ebp+08] ; The size of the buffer
; Local variables:
    %define ts_sign dword [ebp-04] ; Sign of the number
; Return:
;   EAX: Returns the pointer to the start of the converted string
;   EBX: Number of bytes used to convert
to_string:
    enter 4,0

    mov ts_sign, IS_POSITIVE

    ; Check if the number is negative
    push ts_value
    call get_sign
    cmp eax, IS_NEGATIVE
    jne .ts_is_positive
        neg ts_value
        mov ts_sign, IS_NEGATIVE
    .ts_is_positive:

    mov eax, ts_value
    mov ebx, ts_size
    add ts_buffer, ebx
    mov esi, ts_buffer
    mov byte [esi],STRING_TERMINATOR
    mov ebx,10         
    sub ecx, ecx
    
    .next:
    xor edx, edx  
    div ebx      
    add dl, '0'
    dec esi   
    mov [esi], dl
    inc ecx
    test eax, eax            
    jnz .next 

    mov eax, esi
    mov ebx, ecx

    ; If the number is negative, add the '-' char at the start of the string
    cmp ts_sign, IS_NEGATIVE
    jne .ts_is_positive2
        dec eax
        inc ebx
        mov [eax], byte '-'
    .ts_is_positive2:
    
    leave
    ret 12


    ; Brief: Prints a char* on terminal of size size
; Declaration: void print_screen(char* msg, int size);
; Params:
    %define msg dword [ebp + 12] ; Pointer to the message do be printed
    %define msg_size dword [ebp + 8] ; Size of the message
; Local variables:
; Return:
;   - None
print_screen:
    enter 0,0
    
    mov eax, 4
    mov ebx, 1
    mov ecx, msg        ; pointer to the buffer
    mov edx, msg_size   ; size to be read
    int 0x80
    
    leave
    ret 8




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


; Brief: Prints a breakline
; Declaration: void print_screen(char* msg, int size);
; Params:
; Local variables:
; Return:
;   - None
print_break:
    enter 0,0

    mov eax, 4
    mov ebx, 1
    mov ecx, breakline       ; pointer to the buffer
    mov edx, 2               ; size to be read
    int 0x80

    leave
    ret 

