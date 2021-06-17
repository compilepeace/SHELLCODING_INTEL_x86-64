; Author: Abhinav Thakur
; Email : compilepeace@gmail.com
;
; Description: demonstrates defining data of various sizes.
;



segment .data
a    dd  4
b    dd  5.76
c    times   10 dd 0        ; array of 10 double words
d    dw     1, 2            ; array [1, 2]
e    db     0xfb            ; 
f    db     "hello Abhinav", 0      ; byte array

segment .bss
g   resd    1
h   resd    10
i   resb    100

segment .text
global _start         ; let the linker know about main

_start:
    push    rbp         ; set up stack frame for main
    mov     rbp, rsp    ; rsp & rbp pointing to rbp's value 
    sub     rsp, 0x10   ; leave rsp on a 16 byte boundary

    xor     rax, rax    ; return value set to 0
    leave               ; function prologue
    ret