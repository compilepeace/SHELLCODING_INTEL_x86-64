; Author : Abhinav Thakur
; Email  : compilepeace@gmail.com 
;
; Description : The shellcode is prepared by using the famous JMP-CALL-POP method. The 
;				payload generated will print the message "Hello Critical ^_~" once it
;				successfully gets executed by the Intel x86-64 bit processor
;
; SHELLCODE LENGTH : 54 bytes
;	

global _start


section .text
_start:

	jmp	push_address		; Transfers control to push address whose basic existence
							; is to dynamically figure out the address of 'msg' by 
							; pushing address of 'msg' onto the stack

shellcode_function:
	
	; Print message
	pop rsi					; pops off the value at top of stack (address of 'msg') into RSI 
	xor	rax, rax			; Zero out RAX
	mov	al, 0x1				; Syscall number for write()
	mov	rdi, rax			; RDI = 0x1 (file descriptor)
	mov	rdx, rax			
	add	rdx, 0x11			; ADD 17 to 0x1 (i.e. size of msg)
	syscall


	; Exit peacefully
	xor	rax, rax
	mov	rdi, rax			; Exit status
	mov	al, 0x3c			; Syscall number - 60 
	syscall					; exit() syscall

	
		


push_address:
	call	shellcode_function					; pushes the address of msg on top of stack and
												; transfers control to shellcode_function.
	msg:	db	"Hello Critical ^_~", 0xa		; 18 bytes message
