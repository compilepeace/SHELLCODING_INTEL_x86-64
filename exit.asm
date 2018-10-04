; Author : Abhinav Thakur
; Email  : compilepeace@gmail.com
; Description : EXIT SHELLCODE
;
; Assemble shellcode into object file: $ nasm -f elf64 nasm.asm -o nasm.o


global _start

section .text
_start:
		
	xor	rax, rax				; Zero out RAX
	mov dil, al					; EXIT_STATUS
	add al, 0x3c				; exit() syscall number - 60
	syscall
