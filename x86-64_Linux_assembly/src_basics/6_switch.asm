; Author: Abhinav Thakur
; Email : compilepeace@gmail.com
; 
; Description: Implementation to switch code construct
;
; Syscall convention for x86-64 System V ABI: 
;       RDI, RSI, RDX, RCX, R8, R9 
;
; Compile: 
;   yasm -f elf64 -g dwarf2 -l <name>.lst <name>.asm
;   ld <name>.o -o <name>
;

segment .data
switch: dq  _start.case0
        dq  _start.case1
        dq  _start.case2
i       dq  2


segment .text
global _start

_start:
    mov rax, qword [i]      ; rax = i (index for switch statements)
    jmp [switch + rax*8]    ; switch (i)

.case0:
    mov rbx, 0x100
    jmp .end 
.case1:
    mov rbx, 0x200
    jmp .end
.case2:
    mov rbx, 0x300
    jmp .end

.end:
    xor eax, eax
    ret