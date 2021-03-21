; Author: Abhinav Thakur
; Email : compilepeace@gmail.com
;
; Description: calculates slope of a line segment.
;               slope = tan(theita) = height/base
;
segment .data
x1      dd  8
y1      dd  10
x2      dd  8
y2      dd  1
flag    dw  0
quo     dq  0

segment .text
global _start

_start:
    push    rbp
    mov     rbp, rsp

    ; 0 value in a register
    mov     r12d, 0

    ; calculating base length = x2 - x1
    mov     eax, dword [x1]
    sub     eax, dword [x2]
    cmovz   r12w, word [flag]   ; clear the flag if difference is 0
    jz      _exit

    mov     rbx, rax            ; save base length in ebx

    ; calculating height = y2 - y1
    mov     eax, dword [y1]
    sub     eax, dword [y2]
    cmovz   r12w, word [flag]   ; clear the flag if difference is 0
    jz      _exit

    ; signed divide RDX:RAX by r/m32 with result stored in RAX & RDX.
    ;
    cdq     ; copying sign bit of EAX to every bit position in EDX register.
    idiv    ebx                 ; slope = height/base (rax has height, rbx has base)
    cmp     eax, 0
    jl      remove_sign        
    mov     qword [quo], rax    ; rax stores quotient

_exit:
    mov     eax, 60
    mov     edi, 0xb
    syscall

remove_sign:
    neg     eax