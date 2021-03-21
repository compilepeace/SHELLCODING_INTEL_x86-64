; Author: Abhinav Thakur
; Email : compilepeace@gmail.com
;
; Description:  computes the distance squared between 2 points
;               in a plane with coordinates (x1, y1) & (x2, y2).
;

; coordinates here to be read from end user
segment .data
x1  dd  3
y1  dd  10
x2  dd  8
y2  dd  1

segment .text
global _start

_start:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 0x10       ; align stack pointer on a 16 byte boundary
    
    mov     eax, dword [x1]
    sub     eax, dword [x2]
    imul    eax, eax        ; eax = (x1-x2)**2
    
    mov     ebx, eax        ; save previous result in ebx
    
    mov     eax, dword [y1]
    sub     eax, dword [y2]
    imul    eax, eax
    
    add     eax, ebx
    
    add     rsp, 0x10
    mov     rsp, rbp
    pop     rbp