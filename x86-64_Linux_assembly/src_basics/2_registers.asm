; Author: Abhinav Thakur
; Email : compilepeace@gmail.com
;
; Description: demonstrates defining data of various sizes.
;


segment .data
p1  dd  2
p2  dd  0xc
p3  dd  -1
p4  dd  -0xa

segment .text
global _start

_start:
    mov ebx, [p1]       ; ebx = 2
    add ebx, [p2]       ; ebx += 0xc
    mov ecx, [p3]       ; ecx = -1      (0xffffffff)
    add ecx, [p4]       ; ecx += -0xa   (0xfffffff5)
    mov eax, ebx        ; eax = ebx
    add eax, ecx        ; eax += ecx


    ; moving with sign/zero extension
    mov     [p1], rax           ; p1 = rax
    movsxd  rax, dword [p4]            
    movzx   rbx, word [p4]   
