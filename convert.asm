section .data
    STRING_TERMINATOR equ 0


section .text


global stoi
global to_string


extern IS_NEGATIVE
extern IS_POSITIVE
extern get_sign


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

