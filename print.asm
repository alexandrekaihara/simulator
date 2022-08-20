section .data
    global breakline
    breakline db 0dH, 0ah


section .bss


section .text


global print_int
global print_break
global print_screen
global print_object_file
global print_screen_log
global print_int_log
global print_break_log


extern to_string
extern stoi
extern SIZE
extern buffer
extern to_string
extern log
extern LOG_ACTIVE


; Brief: Prints a char* on terminal of size size
; Declaration: void print_int(int value);
; Params:
    %define value dword [ebp+8] ; Integer to be printed
; Local variables:
; Return:
;   - None
print_int:
    enter 0,0
    
    push value
    push dword buffer
    push dword SIZE
    call to_string
    push eax
    push ebx
    call print_screen
    call print_break
    
    leave
    ret 4


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


; Brief: Prints all object file numbers
; Declaration: void print_object_file(int* file, int size);
; Params:
    %define pof_file dword [ebp+12] ; Pointer to the integers array
    %define pof_size dword [ebp+08] ; Integer to be printed
; Local variables:
; Return:
;   - None
print_object_file:
    enter 0,0
    
    mov ecx, pof_size

    .print_loop:
    mov pof_size, ecx
      mov eax, pof_file
      mov eax, [eax]  ; get integer
      push eax
      push dword buffer
      push dword SIZE
      call to_string
      push eax
      push ebx
      call print_screen_log
      call print_break_log
      add pof_file, 4     ; get next integer
    mov ecx, pof_size
    loop .print_loop
    .end_print_loop:

    leave
    ret 8

    

; Brief: Prints a log trace
; Declaration: void print_screen_log(char* msg, int size);
; Params:
    %define psl_msg dword [ebp + 12] ; Pointer to the message do be printed
    %define psl_msg_size dword [ebp + 8] ; Size of the message
; Local variables:
; Return:
;   - None
print_screen_log:
    enter 0,0
    
    cmp [log], dword LOG_ACTIVE
    jne .psl_not_print

    push dword psl_msg      
    push dword psl_msg_size 
    call print_screen

    .psl_not_print:
    
    leave
    ret 8


; Brief: Prints a int on terminal for log purposes
; Declaration: void print_int_log(int value);
; Params:
    %define pil_value dword [ebp+8] ; Integer to be printed
; Local variables:
; Return:
;   - None
print_int_log:
    enter 0,0
    
    cmp [log], dword LOG_ACTIVE
    jne .pil__not_print

    push pil_value
    push dword buffer
    push dword SIZE
    call to_string
    push eax
    push ebx
    call print_screen
    call print_break

    .pil__not_print:
    
    leave
    ret 4


; Brief: Prints a breakline
; Declaration: void print_screen(char* msg, int size);
; Params:
; Local variables:
; Return:
;   - None
print_break_log:
    enter 0,0

    cmp [log], dword LOG_ACTIVE
    jne .pbl__not_print

    mov eax, 4
    mov ebx, 1
    mov ecx, breakline       ; pointer to the buffer
    mov edx, 2               ; size to be read
    int 0x80

    .pbl__not_print:

    leave
    ret 
