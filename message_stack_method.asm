; Author : Abhinav Thakur
; Email  : compilepeace@gmail.com
;
; Description : This code generates a payload which prints the message "Hello Critical\n" 
;				on STDOUT. Code generates shellcode by using Stack Technique.
;
; SHELLCODE LENGTH : 46 bytes	
;

global _start


section .text
_start:
	
	; Print a message
	xor	rax, rax				; Zero out RAX
	add rax, 0x1				; Syscall number
	mov	rdi, rax				; File descriptor
	push 0x0a206461 			 
	mov	rbx, 0x3344206f6c6c6548
	push rbx
	mov rsi, rsp				; mov the address of the top of stack in RSI
	xor rdx, rdx				; Zero out RDX
	mov dl, 0x0b				; String size = 12 bytes
	syscall
		
	
	; Exit peacefully
	xor rax, rax
	mov rdi, rax				; Exit status
	mov al, 0x3c				; Syscall number - 60
	syscall	
	
