/*

Author: Abhinav Thakur
File:   msg_to_stdout.s
Compile:        $ gcc -Wl,-N -nostdlib -static msg_to_stdout.s -o ./msg_to_stdout.elf
Dump shellcode :$ objcopy --dump-section .text=msg_to_stdout.raw ./msg_to_stdout.elf
Run            :$ ./msg_to_stdout.elf

There are 3 approaches that I can think to get the address of message string (data bytes)

1. Use stack to store message string and later move rsp -> rsi
2. Use jmp-call-pop technique, i.e. poping into rsi
3. Use RIP-relative addressing, i.e. refering to msg string via offset relative to RIP

*/

.global _start
_start:
.intel_syntax noprefix

	/* Using RIP-relative addressing approach (3) to retrieve address of msg data bytes */
	jmp hello
	
/*
String defined above to eliminate NULL byte generation (as relative address will be a negative
offset to RIP, therefore will contain 0xffff... instead of 0x0000...
*/
msg:
.asciz "compilepeace was here x_x\n"		/* ask assembler to add NULL @ endof byte stream */
msg_end:
.set msg_len, msg_end-msg

hello:
	/* write (1, "compilepeace was here x_x\n", 26);  */
	push 1
	pop rdi
	// RIP relative addressing (gas syntax)
	lea rsi, [msg+rip]	/* rsi = msg; quite intuitive in NASM syntax : [rel msg] */
	push msg_len			
	pop rdx				/* rdx = msg length (27) */
	push 1
	pop rax				/* rax = 1 (syscall number) */
	syscall

	/* exit (7) */
	push 7
	pop rdi				/* rdi = 7 (exit status) */
	push 60
	pop rax				/* rax = 60 (syscall number) */
	syscall

/*

Alternatively, below is how one can use stack to store & refer (1) to msg data string.
size is more than other 2 techniques but guaranteed to generate NO NULL chars.

	// write (1, "compilepeace was here x_x\n", 26); 
	xor rdi, rdi
	push rdi						// push a NULL QUADWORD on stack (string termination) 
	inc rdi							// rdi = 1 (STDOUT_FILENO) 
	mov word ptr [rsp], 0x0a78		// "\nx" 
	mov rax, 0x5f78206572656820
	push rax						// " here x_" (in LE byte order) 
	mov rax, 0x7361772065636165
	push rax						// "eace was" (in LE byte order)
	mov rax, 0x70656c69706d6f63
	push rax						// "compilep" (in LE byte order)
	push rsp
	pop rsi							// rsi => rsp (points to -> "compil.....\n" on stack) 
	push 26
	pop rdx							// rdx => 26 (msg length) 
	push 1
	pop rax							// rax => 1 (syscall number) 
	syscall
*/
