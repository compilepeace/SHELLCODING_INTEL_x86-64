; Author : Abhinav Thakur
; Email  : compilepeace@gmail.com
; 
; Description : The code uses RIP relative addressing technique to place address of string
;				"Hello Critical ^_~\n" into RSI. That is the code uses RIP to point to executable
;				instructions in .text section.
;
; SHELLCODE LENGHT = 55 Bytes 



global _start
; default rel				; This instruction will ensure the usage of RIP relative addressing
							; wherever it finds a variable/label being addresses


section .text
_start:
	
	jmp	shellcode
	message:	db	"Hello Critical ^_~",0xa


shellcode:

	; Print our message
	xor	rax, rax			; Zero out RAX
	add	rax, 0x1			; Syscall number of write() - 0x1
	mov rdi, rax			; File descriptor - 0x1 (STDOUT)
	lea rsi, [rel message]	; Addresses the label relative to RIP (Instruction Pointer), i.e. 
							; dynamically identifying the address of the 'message' label.
	xor rdx, rdx
	mov dl, 0x13			; message size = 19 bytes (0x13)
	syscall					


	; Exit peacefully
	xor	rax, rax			; Zero out RAX
	mov rdi, rax			; Exit status
	mov al, 0x3c			; exit() syscall number - 60 (0x3c)
	syscall					

	
