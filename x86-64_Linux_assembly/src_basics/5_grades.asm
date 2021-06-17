; Author: Abhinav Thakur
; Email : compilepeace@gmail.com
; 
; Description: to calculate average of 4 grades.s
;
; Syscall convention for x86-64 System V ABI: 
;       RDI, RSI, RDX, RCX, R8, R9 
;
; Compile: 
;   yasm -f elf64 -g dwarf2 -l <name>.lst <name>.asm
;   ld <name>.o -o <name>
;

segment .data
grade1  dd  98
grade2  dd  95
grade3  dd  92
grade4  dd  88
average dd  0

segment .text
global _start

_start:
    push    rbp
    mov     rsp, rbp
    sub     rsp, 0x16

    mov     eax, dword [grade1]
    add     eax, dword [grade2]
    add     eax, dword [grade3]
    add     eax, dword [grade4]
    
    mov     r12d, 4
    xor     edx, edx
    div     r12
    
    mov     dword [average], eax

_exit:
    mov     eax, 60
    mov     edi, 0xb
    syscall
