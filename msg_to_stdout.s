/*

Author: Abhinav Thakur
File:   msg_to_stdout.s
Compile:        $ gcc -Wl,-N -nostdlib -static msg_to_stdout.s -o ./msg_to_stdout.elf
Dump shellcode :$ objcopy --dump-section .text=msg_to_stdout.raw ./msg_to_stdout.elf
Run            :$ ./msg_to_stdout.elf

*/

.global _start
_start:
.intel_syntax noprefix

	/* write (1, "compilepeace was here x_x\n", 26);  */
	xor rdi, rdi
	push rdi		/* push a NULL QUADWORD on stack (string termination) */
	inc rdi			/* rdi = 1 (STDOUT_FILENO) */	
	mov word ptr [rsp], 0x0a78	/* "\nx" */
	mov rax, 0x5f78206572656820
	push rax		/* " here x_" (in LE byte order) */ 
	mov rax, 0x7361772065636165
	push rax		/* "eace was" (in LE byte order) */ 
	mov rax, 0x70656c69706d6f63
	push rax		/* "compilep" (in LE byte order) */	
	push rsp
	pop rsi			/* rsi = rsp (points to -> "compil.....\n" on stack) */
	push 26			
	pop rdx			/* rdx = 26 (msg length) */
	push 1
	pop rax			/* rax = 1 (syscall number) */
	syscall

	/* exit (7) */
	push 7
	pop rdi			/* rdi = 7 (exit status) */
	push 60
	pop rax			/* rax = 60 (syscall number) */
	syscall
