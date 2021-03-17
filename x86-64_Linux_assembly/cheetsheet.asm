; Author: Abhinav Thakur
; Email : compilepeace@gmail.com
; 
; Description: cheetsheet using majority of instructions in use
; Syscall convention for x86-64 System V ABI: RDI, RSI, RDX, RCX, R8, R9 
;
; Compile: 
;   yasm -f elf64 -g dwarf2 -l cheetsheet.lst ./cheetsheet.asm
;   ld cheetsheet.o  -o cheetsheet

segment .data
var1    dd  1998                ; after assembling 'var1' will be replaced with an address
var2    dq  4097
name    db  "Abhinav", 0x0
arr1    times 10 dq 1           ; array of 10 quad words initialized by with value 1
arr2    times 5 dw  7           ; array of 5 words (2 bytes) initialized with value 7


segment .bss
arr3    times 5 dw  7           ; array of 5 words (2 bytes) (.bss is zero initialized)


segment .text
global _start

_start:
    ; RDI, RSI, RDX, RCX, R8, R9 
    ; ssize_t write (int fd, const void *buf, size_t count)
    xor rax, rax
    mov rdi, rax
    mov dil, 0x2        ; fd = stderr
    mov rsi, name       ; buf = name
    xor rdx, rdx
    add rdx, 8          ; count = 8
    mov rax, 1          ; syscall number = 1
    syscall

;----------------------------------------------------------------------------------------------------
    ; mov instruction
    mov rax, 0xaaaaaaaaaaaaaaaa
    mov [var2], rax             ; moving into memory (var2 = 0xaaaaaaaaaaaaaaaa)
    mov rax, var1               ; load an immediate value
    mov eax, [var1]             ; load from memory

    ; moving a constant/immediate value
    ; If you specify a 8-bit register such as al or a 160bit register
    ; such as ax, the remaining bits of the register are unaffected.
    ; However, if you specify a 32-bit register such as eax, the 
    ; remaining bits (upper 32-bits) are cleared out (set to 0).
    mov rax, 0xaaaaaaaaaaaaaaaa
    mov rax, 0x64
    mov rax, 0xaaaaaaaaaaaaaaaa
    mov eax, 0x64               ; same as- mov rax, 0x64 (clearing off upper 32 bits of rax)


    ; mov'ing with zero/sign extension (movsx, movzx, movsxd)
    ; extension instructions seems to work only on byte & word sizes
    ; in case you want to move a dword, use special instruction movsxd.
    mov     rax, 0xbbbbbbbbbbbbbbbb
    movsx   rax, byte [name + 3]        ; access 4th byte starting from label/address 'name'
    movzx   rbx, word [arr2]
    movsxd  rcx, dword [var1]
    nop
 ;----------------------------------------------------------------------------------------------------

    ; void _exit(int status);
    xor rax, rax
    add rax, 60
    mov rdi, 0x10
    syscall
