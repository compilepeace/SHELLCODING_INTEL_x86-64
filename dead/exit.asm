; Author : Abhinav Thakur
; Email  : compilepeace@gmail.com
;
; Description : Code to generate a simple exit syscall shellcode
;
; SHELLCODE LENGTH = 10 bytes
; 


global _start

section .text
_start:
		
	xor rax, rax				; Zero out RAX
	mov dil, al					; EXIT_STATUS
	add al, 0x3c				; exit() syscall number - 60
	syscall
